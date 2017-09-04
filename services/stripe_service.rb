require 'stripe'
Stripe.api_key = ENV["STRIPE_API_PRIVATE_KEY"]

class StripeService
  def self.connect_charge(props)
    begin
      Stripe::Charge.create(
        amount: amount(props[:amount]),
        currency: props[:currency] || "usd",
        card: props[:stripeToken],
        description: props[:description] || "Description",
        destination: {account: props[:destination]},
      )
    rescue Stripe::InvalidRequestError => e
      halt e.http_status, json({
        message: e.message
      })
    end
  end

  private
  def self.amount(props_amount)
    calculated_amount = ((props_amount.to_f)*100).to_i
    halt 422, json({
      message: "Expected positive amount"
    }) unless calculated_amount.positive?
    calculated_amount
  end
end
