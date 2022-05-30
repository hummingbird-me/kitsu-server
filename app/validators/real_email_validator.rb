# This is a validator which uses emailable.com to validate an email address before saving
class RealEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attr, value)
    return if value.blank?

    response = Accounts::PrevalidateEmail.call(email: value)

    record.errors.add(attr, message: 'could not be delivered to') if response.result.undeliverable?
  end
end
