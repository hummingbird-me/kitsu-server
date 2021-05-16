class ShrineAttachmentFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    return nil if value.blank?
    raise 'Invalid attachment field' unless value.is_a? Shrine::UploadedFile

    { original: value.url, meta: {} }
  end
end
