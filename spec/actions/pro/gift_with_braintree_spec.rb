require 'rails_helper'

RSpec.describe Pro::GiftWithBraintree do
  let(:alice) { build(:user) }
  let(:bob) { build(:user) }

  it 'should charge the user the amount for the tier' do
    expect($braintree).to receive_message_chain(:transaction, :sale!).with(
      match_json_expression({
        amount: '49.00',
        payment_method_nonce: 'fake-paypal-one-time-nonce',
        options: {
          submit_for_settlement: true
        }
      }.ignore_extra_keys!)
    )

    Pro::GiftWithBraintree.call(
      tier: 'patron',
      nonce: 'fake-paypal-one-time-nonce',
      from: alice,
      to: bob
    )
  end
end
