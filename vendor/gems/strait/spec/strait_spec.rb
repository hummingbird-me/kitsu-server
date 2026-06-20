# frozen_string_literal: true

require 'mock_redis'
require 'strait'

RSpec.describe Strait do
  let(:redis) { MockRedis.new }
  let(:pool) { ConnectionPool.new(pool: 1) { redis } }
  let(:config) { OpenStruct.new(redis_pool: pool) }

  describe '#limit!' do
    it 'should raise an exception when the user goes over the defined limits' do
      Strait.configuration = {}

      strait = Strait.new('test') do
        limit 5, per: 60
      end
      strait.instance_variable_set(:@config, config)

      5.times { strait.limit!('mirai') }
      expect {
        strait.limit!('mirai')
      }.to raise_error(Strait::RateLimitExceeded)
    end
  end

  describe '.configuration=' do
    it 'should change the Strait::Configuration.default' do
      Strait.configuration = { redis: { url: 'test' } }
      expect(Strait::Configuration.default.dig(:redis, :url)).to eq('test')
    end
  end
end
