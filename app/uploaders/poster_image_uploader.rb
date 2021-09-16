require 'image_processing/vips'

class PosterImageUploader < Shrine
  prepend ImageUploader
  prepend PublicUploader

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

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DERIVATIVES.transform_values { |proc| proc.call(vips) }
  end
end
