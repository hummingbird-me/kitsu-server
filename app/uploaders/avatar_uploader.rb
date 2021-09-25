require 'image_processing/vips'
require 'image_processing/mini_magick'

class AvatarUploader < Shrine
  include ImageUploader
  include PublicUploader

  DERIVATIVES = {
    magick: {
      tiny: ->(magick) {
        magick.resize_to_fill(40, 40).set('dispose', 'background').convert(:gif).call
      },
      tiny_webp: ->(magick) {
        magick.resize_to_fill(40, 40).set('dispose', 'background').convert(:webp).call
      },
      small: ->(magick) {
        magick.resize_to_fill(64, 64).set('dispose', 'background').convert(:gif).call
      },
      small_webp: ->(magick) {
        magick.resize_to_fill(64, 64).set('dispose', 'background').convert(:webp).call
      },
      medium: ->(magick) {
        magick.resize_to_fill(100, 100).set('dispose', 'background').convert(:gif).call
      },
      medium_webp: ->(magick) {
        magick.resize_to_fill(100, 100).set('dispose', 'background').convert(:webp).call
      },
      large: ->(magick) {
        magick.resize_to_fill(200, 200).set('dispose', 'background').convert(:gif).call
      },
      large_webp: ->(magick) {
        magick.resize_to_fill(200, 200).set('dispose', 'background').convert(:webp).call
      }
    },
    vips: {
      tiny: ->(vips) {
        vips.resize_to_fill(40, 40).convert(:jpeg).saver(quality: 100, strip: true).call
      },
      small: ->(vips) {
        vips.resize_to_fill(64, 64).convert(:jpeg).saver(quality: 80, strip: true).call
      },
      medium: ->(vips) {
        vips.resize_to_fill(100, 100).convert(:jpeg).saver(quality: 70, strip: true).call
      },
      large: ->(vips) {
        vips.resize_to_fill(200, 200).convert(:jpeg).saver(quality: 60, strip: true).call
      }
    }
  }.freeze

  Attacher.derivatives do |original|
    info = ImageInfo.new(original.path)
    if info.animated?
      magick = ImageProcessing::MiniMagick.source(original).loader(loader: info.type)
      DERIVATIVES[:magick].transform_values { |proc| proc.call(magick) }
    else
      vips = ImageProcessing::Vips.source(original)
      DERIVATIVES[:vips].transform_values { |proc| proc.call(vips) }
    end
  end
end
