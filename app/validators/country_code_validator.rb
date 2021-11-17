class CountryCodeValidator < ActiveModel::EachValidator
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
    nil if IsoCountryCodes.find(value).present?
  rescue IsoCountryCodes::UnknownCodeError
    "#{value} is not a known ISO 3166-1 country code"
  end
end
