# This is a validator which uses thechecker.co to validate an email address before saving
class RealEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attr, value)
    return if value.blank?

    response = Accounts::PrevalidateEmail.call(email: value)

    record.errors[attr] << 'could not be delivered to' if response.result.undeliverable?
  end
end
