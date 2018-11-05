class StripeGiftService
  def initialize(from:, to:, token:)
    @from = from
    @to = to
    @token = token
  end

  def call
    Stripe::Charge.create(
      # 1 year of PRO
      amount: 29_99,
      currency: 'usd',
      description: 'Kitsu Pro Gift',
      statement_descriptor: 'Kitsu Pro Gift',
      source: @token,
      metadata: {
        gift: true,
        to: @to.id,
        from: @from.id
      }
    )
  end
end
