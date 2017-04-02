module WithAvatar
  extend ActiveSupport::Concern

  included do
    has_attached_file :avatar, styles: {
      tiny: '40x40#',
      small: '64x64#',
      medium: '100x100#',
      large: '200x200#'
    }, convert_options: {
      tiny: '-quality 100 -strip',
      small: '-quality 80 -strip',
      medium: '-quality 70 -strip',
      large: '-quality 60 -strip'
    }, only_process: %i[large original]
    validates_attachment :avatar, content_type: {
      content_type: %w[image/jpg image/jpeg image/png image/gif]
    }
    # Accept 1:10 through 10:1
    validates :cover_image, image_dimensions: { aspect_ratio: 0.1..10 }
    process_in_background :avatar,
      only_process: %i[tiny small medium],
      processing_image_url: ->(avatar) {
        interpolator = avatar.options[:interpolator]
        interpolator.interpolate(avatar.options[:url], avatar, :large)
      }
  end
end
