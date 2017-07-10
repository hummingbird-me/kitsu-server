class ExclusivityValidator < ActiveModel::Validator
  attr_reader :attrs, :limit

  def initialize(options)
    super
    @attrs = options[:on]
    @limit = options[:limit] || 1
  end

  def validate(record)
    values = attrs.map { |a| record.public_send(a) }
    present_count = values.count(&:present?)

    return if present_count <= limit

    attrs.each do |attr|
      other_attrs = attrs - [attr]
      message = "cannot be set while #{other_attrs.join(', ')} are present"
      record.errors.add(attr, message)
    end
  end
end
