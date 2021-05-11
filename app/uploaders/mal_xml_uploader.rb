class MALXMLUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type %w[application/gzip application/xml]
  end
end
