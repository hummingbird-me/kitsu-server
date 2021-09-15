class ShrineAttachmentValueFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    raise 'Invalid attachment field' unless value.is_a? Shrine::Attacher
    return nil if value.blank? || value.file.blank?

    output = value.derivatives.transform_values(&:url)
    output[:original] = value.file.url

    styles_dims = value.derivatives.transform_values do |derivative|
      {
        width: derivative.width,
        height: derivative.height
      }
    end
    output[:meta] = { dimensions: styles_dims }

    output
  end
end
