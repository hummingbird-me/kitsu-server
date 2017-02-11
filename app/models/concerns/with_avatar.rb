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
    }
    validates_attachment :avatar, content_type: {
      content_type: %w[image/jpg image/jpeg image/png image/gif]
    }
    process_in_background :avatar
  end
end
