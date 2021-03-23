require 'rails_helper'

RSpec.describe Accounts::PrevalidateEmail do
  before { stub_const('Accounts::PrevalidateEmail::API_KEY', 'fake-api-key') }

  context 'when the server times out' do
    before { stub_request(:any, /api\.emailable\.com/).to_timeout }

    it 'should return the default unknown response' do
      res = described_class.call(email: 'email')
      expect(res.result).to be_unknown
      expect(res.reason).to be_timeout
    end
  end

  context 'when it gets an undeliverable email address' do
    before do
      stub_request(:any, /api\.emailable\.com/).to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: {
          email: 'email',
          user: 'user',
          domain: 'domain',
          free: false,
          did_you_mean: 'uuuuser',
          state: 'undeliverable',
          reason: 'invalid_email'
        }.to_json
      )
    end

    it 'should return an undeliverable response' do
      res = described_class.call(email: 'email')
      expect(res.result).to be_undeliverable
      expect(res.reason).to be_invalid_email
    end
  end
end
