# frozen_string_literal: true

class Types::Scalar::NumericOperator < Types::Scalar::Base
  description ''

  PARSER = /\A(!=|>=|<=|>|<|=){1,2}\s(\d+)/.freeze
  NUMERIC_OPERATORS = %w(= != > >= < <=).freeze

  def self.coerce_input(input_value, _context)
    matches = PARSER.match(input_value)

    custom_validate_input(matches, input_value)

    "#{matches[1].strip} #{matches[2]}"
  end

  def self.custom_validate_input(matches, input_value)
    return if matches && !matches[2].to_i.zero?

    raise GraphQL::CoercionError, "#{input_value} is not valid."
  end
end
