class ImageDimensionsValidator < ActiveModel::EachValidator
  def validate_each(_record, attr, value)
    size = dimensions_for(value)

    height = options[:height]
    width = options[:width]
    ratio = options[:width] / options[:height]

    record.errors[attr] << validate_value('Height', height, size.height)
    record.errors[attr] << validate_value('Width', width, size.width)
    record.errors[attr] << validate_value('Aspect ratio', ratio, size.ratio)
  end

  def dimensions_for(attachment)
    file = attachment.queued_for_write[:original].path
    Paperclip::Geometry.from_file(file)
  end

  def validate_value(name, value, target)
    return true unless target
    return true if target === value # rubocop:disable Style/CaseEquality

    if target.respond_to?(:begin) && target.respond_to?(:end)
      "#{name} must be between #{target.begin} and #{target.end}"
    else
      "#{name} must be #{target}"
    end
  end
end
