# frozen_string_literal: true

require 'strait/configuration'
require 'strait/dsl'
require 'strait/rate_limit_exceeded'
require 'strait/rule'
require 'strait/version'

# A rate-limiter which provides natural defenses for your nation-state. Or your API.
class Strait
  attr_reader :name, :config

  def initialize(name, rules: [], **config, &block)
    @name = name
    @raw_rules = rules
    @config = Strait::Configuration.default.merge(config)

    @raw_rules += Strait::DSL.new(&block).rules unless block.nil?
  end

  def limit!(user)
    # Build a hash of { rule => acceptable } structure
    results = rules.map { |rule| [rule, rule.call(user)] }.to_h

    return if results.values.all?(true)

    # Raise an exception for the first rate limit hit
    results.each do |rule, acceptable|
      raise Strait::RateLimitExceeded.new(**rule.to_h) unless acceptable
    end
  end

  def self.configuration=(config)
    Strait::Configuration.default = Strait::Configuration.new(config)
  end

  private

  def rules
    @rules ||= @raw_rules.map do |rule|
      if rule.is_a?(Strait::Rule)
        rule
      else
        Strait::Rule.new(config: @config, name: @name, rule: rule)
      end
    end
  end
end
