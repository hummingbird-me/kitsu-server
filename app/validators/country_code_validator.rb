class CountryCodeValidator < ActiveModel::EachValidator
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
    nil if IsoCountryCodes.find(value).present?
  rescue IsoCountryCodes::UnknownCodeError
    "#{value} is not a known ISO 3166-1 country code"
  end
end
