# frozen_string_literal: true

require 'mock_redis'
require 'strait/rule'

RSpec.describe Strait::Rule do
  let(:redis) { MockRedis.new }
  let(:pool) { ConnectionPool.new(pool: 1) { redis } }
  let(:config) { OpenStruct.new(redis_pool: pool) }

  describe '#call' do
    context 'with the rate limit exceeded' do
      let(:rule) do
        Strait::Rule.new(
          name: 'test',
          rule: { period: 60, count: 5, buckets: 60 },
          config: config
        )
      end
      before do
        key = rule.send(:key_for, 'mirai')
        bucket = rule.send(:bucket_for, Time.now.to_i - 10)
        redis.hset(key, bucket, 50)
      end

      it 'should return false' do
        expect(rule.call('mirai')).to be(false)
      end
    end
  end

  it 'should have separate limits for users' do
    rule = Strait::Rule.new(
      name: 'test',
      rule: { period: 60, count: 5, buckets: 60 },
      config: config
    )
    key = rule.send(:key_for, 'akihito')
    bucket = rule.send(:bucket_for, Time.now.to_i - 10)
    redis.hset(key, bucket, 50)

    expect(rule.call('mirai')).to be(true)
  end

  it 'should delete old buckets from the hash' do
    rule = Strait::Rule.new(
      name: 'test',
      rule: { period: 60, count: 5, buckets: 60 },
      config: config
    )
    key = rule.send(:key_for, 'mirai')
    bucket = rule.send(:bucket_for, Time.now.to_i - 120)
    redis.hset(key, bucket, 50)

    expect {
      rule.call('mirai')
    }.to(change { redis.hget(key, bucket) }.to(nil))
  end

  it 'should not raise Strait::RateLimitError for old buckets' do
    rule = Strait::Rule.new(
      name: 'test',
      rule: { period: 60, count: 5, buckets: 60 },
      config: config
    )
    key = rule.send(:key_for, 'mirai')
    bucket = rule.send(:bucket_for, Time.now.to_i - 120)
    redis.hset(key, bucket, 50)

    expect(rule.call('mirai')).to be(true)
  end
end
