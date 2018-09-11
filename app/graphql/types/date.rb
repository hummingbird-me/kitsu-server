class Types::Date < Types::BaseScalar
  description "A date, expressed as an ISO8601 string"

  def self.coerce_input(input_value, context)
    Date.strptime(input_value, '%F')
  rescue ArgumentError
    raise GraphQL::CoercionError, "#{input_value.inspect} is not a valid date"
  end

  def self.coerce_result(ruby_value, context)
    # It's transported as a string, so stringify it
    ruby_value.strftime('%F')
  end
end
