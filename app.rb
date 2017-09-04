Bundler.require :web
Bundler.require :development if development?
require 'sinatra/json'
require 'dotenv/load' if development? || test?
require './services/stripe_service'

before do
  content_type :json
end

after do
  response.body = JSON.dump(response.body)
end

get '/' do
  if params[:amount] && params[:destination] && params[:stripeToken]
    begin
      @charge = StripeService.connect_charge(params)
      params.to_json
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
