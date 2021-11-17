class LanguageCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attr, value)
    if value.respond_to?(:each)
      value.each do |v|
        record.errors[attr] << validate_value(v)
      end
    else
      record.errors[attr] << validate_value(value)
    end

    record.errors[attr].compact!
  end

  def validate_value(value)
    unless ISO_639.find(value).present?
      "#{value} is not a known ISO 639-1 language code"
    end
  end
end
