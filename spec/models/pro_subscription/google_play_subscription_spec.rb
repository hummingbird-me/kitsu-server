require 'rails_helper'

RSpec.describe ProSubscription::GooglePlaySubscription, type: :model do
  describe '#billing_service' do
    it 'should return :google_play' do
      ProSubscription::GooglePlaySubscription.new.billing_service
    end
  end
end
