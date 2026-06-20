# frozen_string_literal: true

class Strait
  class DSL
    attr_reader :rules

    def initialize(&block)
      @rules = []
      instance_eval(&block)
    end

    def limit(count, per:, buckets: 60)
      @rules << { count: count, period: per, buckets: buckets }
    end
  end
end
