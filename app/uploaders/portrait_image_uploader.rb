require 'image_processing/vips'

class PortraitImageUploader < Shrine
  prepend ImageUploader
  prepend PublicUploader

  DERIVATIVES = {
    tiny: ->(vips) {
      vips.resize_to_fill(100, 120).convert(:jpeg).saver(quality: 90, strip: true).call
    },
    small: ->(vips) {
      vips.resize_to_fill(200, 240).convert(:jpeg).saver(quality: 75, strip: true).call
    },
    medium: ->(vips) {
      vips.resize_to_fill(300, 360).convert(:jpeg).saver(quality: 70, strip: true).call
    },
    large: ->(vips) {
      vips.resize_to_fill(500, 600).convert(:jpeg).saver(quality: 60, strip: true).call
    }
  }.freeze

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DERIVATIVES.transform_values { |proc| proc.call(vips) }
  end
end
