class PolymorphismValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid_types = [options[:type]].flatten
    unless valid_types.any? { |type| value.is_a?(type) }
      record.errors[attribute] << (options[:message] || "disallowed type")
    end
  end
end
