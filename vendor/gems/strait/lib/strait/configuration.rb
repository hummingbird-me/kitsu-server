# frozen_string_literal: true

require 'connection_pool'
require 'forwardable'

class Strait
  class Configuration
    extend Forwardable
    attr_accessor :config
    def_delegators :@config, :[], :[]=, :dig

    class << self
      attr_accessor :default
    end

    def initialize(config = {})
      @config = config
    end

    def merge(new_config = nil)
      return self if new_config.nil? || new_config.empty?

      self.class.new(config.merge(new_config))
    end

    def redis_pool
      @redis_pool ||= ConnectionPool.new(config[:pool] || {}) { Redis.new(config[:redis]) }
    end
  end
end
