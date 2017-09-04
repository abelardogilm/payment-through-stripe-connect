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

get '/' do
  if params[:amount].to_f && params[:destination] && params[:stripeToken]
    amount = ((params[:amount].to_f)*100).to_i
    begin
      @charge = Stripe::Charge.create(
        amount: amount,
        currency: "usd",
        card: params[:stripeToken],
        description: "Description",
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
      message: "Bad payload"
    })
  end
end
