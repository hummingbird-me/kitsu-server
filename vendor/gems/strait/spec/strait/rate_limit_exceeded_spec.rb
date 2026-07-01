# frozen_string_literal: true

require 'mock_redis'
require 'strait/rate_limit_exceeded'

RSpec.describe Strait::RateLimitExceeded do
  describe '.new' do
    it 'should require period and count as arguments' do
      expect {
        Strait::RateLimitExceeded.new
      }.to raise_error(ArgumentError)

      expect {
        Strait::RateLimitExceeded.new(period: 60, count: 10)
      }.not_to raise_error
    end
  end

  describe '#to_s' do
    it 'should include the count and period' do
      error = Strait::RateLimitExceeded.new(period: 60, count: 10)
      message = error.to_s
      expect(message).to include('10')
      expect(message).to include('60 seconds')
    end
  end
end
