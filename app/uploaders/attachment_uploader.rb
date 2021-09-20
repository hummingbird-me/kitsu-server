require 'image_processing/vips'
require 'image_processing/mini_magick'

class AttachmentUploader < Shrine
  include ImageUploader
  include PublicUploader
end
