class AttachmentValueFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    raise 'Invalid attachment field' unless value.is_a? Paperclip::Attachment
    return nil if value.blank?

    urls = value.styles.keys.map { |style| [style, value.url(style)] }

    styles_dims = value.styles.keys.map do |style|
      begin
        [
          style,
          {
            width: value.width(style),
            height: value.height(style)
          }
        ]
      rescue ArgumentError
        [style, {}]
      end
    end
    styles_dims = Hash[styles_dims]

    urls << [:original, value.url]
    urls << [
      :meta,
      {
        dimensions: styles_dims
      }
    ]
    Hash[urls]
  end
end
