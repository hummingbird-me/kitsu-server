require 'image_processing/vips'

class UnitThumbnailUploader < Shrine
  include ImageUploader
  include PublicUploader

  DERIVATIVES = {
    tiny: ->(vips) {
      vips.resize_to_fill(160, 90).convert(:jpeg).saver(quality: 95, strip: true).call
    },
    small: ->(vips) {
      vips.resize_to_fill(320, 180).convert(:jpeg).saver(quality: 75, strip: true).call
    },
    medium: ->(vips) {
      vips.resize_to_fill(640, 360).convert(:jpeg).saver(quality: 70, strip: true).call
    },
    large: ->(vips) {
      vips.resize_to_fill(960, 540).convert(:jpeg).saver(quality: 60, strip: true).call
    }
  }.freeze

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)

    DERIVATIVES.transform_values { |proc| proc.call(vips) }
  end
end
