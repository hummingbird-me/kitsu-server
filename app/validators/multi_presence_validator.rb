class MultiPresenceValidator < ActiveModel::Validator
  attr_reader :attrs, :minimum

  def initialize(options)
    super
    @attrs = options[:over]
    @minimum = options[:minimum] || 1
  end

  def validate(record)
    values = attrs.map { |a| [a, record.public_send(a)] }.to_h
    present = values.select { |_, v| v.present? }.keys

    return if present.count >= minimum

    # Apply to non-present fields
    (attrs - present).each do |attr|
      message = "at least #{minimum} of #{attrs.join(', ')} must be present"
      record.errors.add(attr, message)
    end
  end
end
