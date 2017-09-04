Bundler.require :web
Bundler.require :development if development?
require 'dotenv/load'
require 'stripe'
Stripe.api_key = ENV["STRIPE_API_PRIVATE_KEY"]

require 'sinatra/json'

require 'pry'

before do
  content_type :json
end

after do
  response.body = JSON.dump(response.body)
end

def amount
  amount = ((params[:amount].to_f)*100).to_i
  halt 422, json({
    message: "Expected positive amount"
  }) unless amount.positive?
  amount
end

get '/' do
  if params[:amount] && params[:destination] && params[:stripeToken]
    begin
      @charge = Stripe::Charge.create(
        amount: amount,
        currency: params[:currency] || "usd",
        card: params[:stripeToken],
        description: params[:description] || "Description",
        destination: {account: params[:destination]},
        )
      { amount: amount, destination: params[:destination] }.to_json
    rescue Stripe::InvalidRequestError => e
      halt e.http_status, json({
        message: e.message
      })
    end
  else
    halt 422, json({
      message: "Bad payload", payload: params,
    })
  end
end
