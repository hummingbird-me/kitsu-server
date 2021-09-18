require 'image_processing/vips'
require 'image_processing/mini_magick'

class CoverImageUploader < Shrine
  include ImageUploader
  include PublicUploader

  DERIVATIVES = {
    magick: {
      tiny: ->(magick) {
        magick.resize_to_fill(840, 200).set('dispose', 'background').convert(:gif).call
      },
      tiny_webp: ->(magick) {
        magick.resize_to_fill(840, 200).set('dispose', 'background').convert(:webp).call
      },
      small: ->(magick) {
        magick.resize_to_fill(1680, 400).set('dispose', 'background').convert(:gif).call
      },
      small_webp: ->(magick) {
        magick.resize_to_fill(1680, 400).set('dispose', 'background').convert(:webp).call
      },
      large: ->(magick) {
        magick.resize_to_fill(3360, 800).set('dispose', 'background').convert(:gif).call
      },
      large_webp: ->(magick) {
        magick.resize_to_fill(3360, 800).set('dispose', 'background').convert(:webp).call
      }
    },
    vips: {
      tiny: ->(vips) {
        vips.resize_to_fill(840, 200).convert(:jpeg).saver(quality: 90, strip: true).call
      },
      small: ->(vips) {
        vips.resize_to_fill(1680, 400).convert(:jpeg).saver(quality: 75, strip: true).call
      },
      large: ->(vips) {
        vips.resize_to_fill(3360, 800).convert(:jpeg).saver(quality: 50, strip: true).call
      }
    }
  }.freeze

  Attacher.derivatives do |original|
    info = ImageInfo.new(original)
    if info.animated?
      vips = ImageProcessing::Vips.source(original)
      DERIVATIVES[:vips].transform_values { |proc| proc.call(vips) }
    else
      magick = ImageProcessing::MiniMagick.source(original).loader(loader: info.type)
      DERIVATIVES[:magick].transform_values { |proc| proc.call(magick) }
    end
  end
end
