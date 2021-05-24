require 'image_processing/vips'

class PosterImageUploader < Shrine
  DERIVATIVES = {
    tiny: ->(vips) {
      vips.resize_to_fill(110, 156).convert(:jpeg).saver(quality: 90, strip: true).call
    },
    small: ->(vips) {
      vips.resize_to_fill(284, 402).convert(:jpeg).saver(quality: 75, strip: true).call
    },
    medium: ->(vips) {
      vips.resize_to_fill(390, 554).convert(:jpeg).saver(quality: 70, strip: true).call
    },
    large: ->(vips) {
      vips.resize_to_fill(550, 780).convert(:jpeg).saver(quality: 60, strip: true).call
    }
  }.freeze

  plugin :validation_helpers
  plugin :store_dimensions

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DERIVATIVES.transform_values { |proc| proc.call(vips) }
  end

  Attacher.validate do
    validate_mime_type %w[image/jpg image/jpeg image/png image/webp]
  end
end
