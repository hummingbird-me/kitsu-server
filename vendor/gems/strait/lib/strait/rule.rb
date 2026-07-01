# frozen_string_literal: true

class Strait
  class Rule
    def initialize(name:, rule:, config:)
      @name = name
      @rule = rule
      @config = config
    end

    def call(user)
      period_count_for(user) <= @rule[:count]
    end

    def to_h
      @rule
    end

    private

    # Get the in-period hit count for a user
    def period_count_for(user)
      key = key_for(user)
      # Round the timestamp to get the bucket
      bucket_time = bucket_for(Time.now)
      first_bucket = ((Time.now.to_i - @rule[:period]) / bucket_length).floor

      @config.redis_pool.with do |redis|
        redis.hincrby(key, bucket_time, 1)

        # We need to iterate the list once to total the counts, so we use that one iteration to also
        # find any buckets which should be removed.
        results = redis.hgetall(key).each_with_object(total: 0, delete: []) do |(time, count), out|
          if time.to_i < first_bucket
            out[:delete] << time
          else
            out[:total] += count.to_i
          end
        end

        redis.hdel(key, *results[:delete]) unless results[:delete].empty?
        results[:total]
      end
    end

    def bucket_for(time)
      (time.to_f / bucket_length).floor * bucket_length
    end

    def bucket_length
      @bucket_length ||= @rule[:period] / @rule[:buckets]
    end

    def key_for(user)
      "strait:#{@name}-#{@rule[:count]}/#{@rule[:period]}:#{user}"
    end
  end
end
