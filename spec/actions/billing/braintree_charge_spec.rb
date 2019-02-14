require 'rails_helper'

RSpec.describe Billing::BraintreeCharge do
  it 'should cast the amount from BigDecimal to string' do
    action = Billing::BraintreeCharge.new(amount: BigDecimal('4.20'))
    expect(action.amount).to eq('4.20')
  end

  describe 'with a valid one-time paypal nonce' do
    it 'should charge the Braintree nonce' do
      transaction = Billing::BraintreeCharge.call(
        amount: BigDecimal('4.20'),
        nonce: 'fake-paypal-one-time-nonce',
        description: 'Kitsu Pro'
      )

      expect(transaction).to be_a(Braintree::Transaction)
      expect(transaction.status).to eq('settling')
      expect(transaction.payment_instrument_type).to eq(
        Braintree::PaymentInstrumentType::PayPalAccount
      )
    end
  end

  describe 'with an invalid payment nonce' do
    it 'should fail loudly' do
      expect {
        Billing::BraintreeCharge.call(
          amount: BigDecimal('4.20'),
          nonce: 'fake-consumed-nonce',
          description: 'Kitsu Pro'
        )
      }.to raise_error(Braintree::BraintreeError)
    end
  end
end
