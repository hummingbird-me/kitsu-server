module Pro
  class GiftWithBraintree < Action
    parameter :nonce, required: true
    parameter :from, load: User, required: true
    parameter :to, load: User, required: true
    parameter :tier, required: true
    parameter :message

    def call
      Pro::ValidateGift.call(context)
      Billing::BraintreeCharge.call(
        nonce: nonce,
        amount: amount,
        description: "Kitsu #{tier} Gift"
      )
      Pro::SendGift.call(context)
    end

    private

    def amount
      Pro::PRICES[tier]
    end
  end
end
