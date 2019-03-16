require 'rails_helper'

RSpec.describe Pro::CreatePaypalAgreement do
  it 'should create an agreement and return the token' do
    response = Pro::CreatePaypalAgreement.call(user: build(:user), tier: 'pro')
    expect(response.token).to start_with('EC-')
  end
end
