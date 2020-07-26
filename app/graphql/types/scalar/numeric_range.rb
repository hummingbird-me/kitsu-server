# frozen_string_literal: true

class Types::Scalar::NumericRange < Types::Scalar::Base
  description ''

  NUMBER = /(\d+(?:\.\d+)?)/
  NUMERIC_RANGE = /\A#{NUMBER}?(\.{2,3})?#{NUMBER}?\z/

  def self.coerce_input(input_value, _context)
    matches = NUMERIC_RANGE.match(input_value)

    custom_validate_input(matches, input_value)

    # If there is no range, just return.
    return "=#{matches[1]}" if matches[2].blank?

    ":#{start_date(matches[1])} TO #{end_date(matches[3])}"
  end

  def self.custom_validate_input(matches, input_value)
    # You gotta provide at least *one* number
    return if matches && (matches[1].present? || matches[3].present?)

    raise GraphQL::CoercionError, "#{input_value} is not a valid year"
  end

  def self.start_date(date)
    date.presence || 50.years.ago.year
  end

  def self.end_date(date)
    date.presence || Time.zone.today.year
  end
end
