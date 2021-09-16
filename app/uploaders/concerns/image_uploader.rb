module ImageUploader
  extend ActiveSupport::Concern
  include BlurhashUploader

  included do
    plugin :validation_helpers
    plugin :store_dimensions

    self::Attacher.validate do
      validate_mime_type %w[image/jpg image/jpeg image/png image/webp]
    end
  end
end
