require 'image_processing/vips'

class CoverImageUploader < Shrine
  include ImageUploader
  include PublicUploader

  DERIVATIVES = {
    tiny: ->(vips) {
      vips.resize_to_fill(840, 200).convert(:jpeg).saver(quality: 90, strip: true).call
    },
    small: ->(vips) {
      vips.resize_to_fill(1680, 400).convert(:jpeg).saver(quality: 75, strip: true).call
    },
    large: ->(vips) {
      vips.resize_to_fill(3360, 800).convert(:jpeg).saver(quality: 50, strip: true).call
    }
  }.freeze

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DERIVATIVES.transform_values { |proc| proc.call(vips) }
  end
end
