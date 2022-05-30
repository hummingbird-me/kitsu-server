class ExclusivityValidator < ActiveModel::Validator
  attr_reader :attrs, :limit

  def initialize(options)
    super
    @attrs = options[:over]
    @limit = options[:limit] || 1
  end

  def validate(record)
    values = attrs.index_with { |a| record.public_send(a) }
    present = values.select { |_, v| v.present? }.keys

    return if present.count <= limit

    present.each do |attr|
      other_attrs = present - [attr]
      message = "cannot be set while #{other_attrs.join(', ')} are present"
      record.errors.add(attr, message)
    end
  end
end
