module WithCoverImage
  extend ActiveSupport::Concern

  included do
    has_attached_file :cover_image, styles: {
      tiny: ['840x200#', :jpg],
      small: ['1680x400#', :jpg],
      large: ['3360x800#', :jpg]
    }, convert_options: {
      tiny: '-quality 90 -strip',
      small: '-quality 75 -strip',
      large: '-quality 50 -strip'
    }
    validates_attachment :cover_image, content_type: {
      content_type: %w[image/jpg image/jpeg image/png]
    }
  end
end
