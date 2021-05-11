class ShrineAttachmentFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    raise 'Invalid attachment field' unless value.is_a? Shrine::UploadedFile
    return nil if value.blank?

    { original: value.url, meta: {} }
  end
end
