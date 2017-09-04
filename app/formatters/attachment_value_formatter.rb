class AttachmentValueFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    raise 'Invalid attachment field' unless value.is_a? Paperclip::Attachment
    return nil if value.blank?

    urls = value.styles.keys.map { |style| [style, value.url(style)] }
    urls << [:original, value.url]
    urls << [
      :meta,
      {
        dimensions: {
          original: {
            width: value.width,
            height: value.height
          }
        }
      }
    ]
    Hash[urls]
  end
end
