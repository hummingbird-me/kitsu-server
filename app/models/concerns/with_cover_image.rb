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
    }, only_process: %i[small original]
    validates_attachment :cover_image, content_type: {
      content_type: %w[image/jpg image/jpeg image/png]
    }
    validates :cover_image, image_dimensions: { ratio: 1..10 }
    process_in_background :cover_image,
      only_process: %i[tiny large],
      processing_image_url: ->(cover) {
        interpolator = cover.options[:interpolator]
        interpolator.interpolate(cover.options[:url], cover, :small)
      }
  end
end
