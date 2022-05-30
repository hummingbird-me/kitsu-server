class LanguageCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attr, value)
    if value.respond_to?(:each)
      value.each do |v|
        error = validate_value(v)
        record.errors.add(attr, message: error) if error
      end
    else
      error = validate_value(value)
      record.errors.add(attr, message: error) if error
    end
  end

  def validate_value(value)
    unless ISO_639.find(value).present?
      "#{value} is not a known ISO 639-1 language code"
    end
  end
end
