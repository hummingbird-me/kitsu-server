class StripeGiftService
  PRICES = {
    month: 2_99,
    year: 29_99
  }.freeze

  def initialize(from:, to:, token:, length:)
    @from = from
    @to = to
    @token = token
    @length = length
  end

  def call
    Stripe::Charge.create(
      amount: PRICES[@length],
      currency: 'usd',
      description: 'Kitsu Pro Gift',
      statement_descriptor: 'Kitsu Pro Gift',
      source: @token,
      metadata: {
        length: @length.to_s,
        gift: true,
        to: @to.id,
        from: @from.id
      }
    )
  end
end
