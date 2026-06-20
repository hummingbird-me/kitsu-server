# frozen_string_literal: true

class Strait
  class RateLimitExceeded < StandardError
    def initialize(period:, count:, **_other)
      @period = period
      @count = count
    end

    def to_s
      "Rate Limit Exceeded: #{@count} per #{@period} seconds"
    end
  end
end
