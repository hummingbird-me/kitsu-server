class Types::Image < Types::BaseObject
  field :original, Types::ImageView,
    null: false,
    description: 'The original image'

  field :views, [Types::ImageView],
    null: false,
    description: 'The various generated views of this image' do
      argument :names, [String], required: false
    end

  def original
    {
      name: 'original',
      url: object.url(:original),
      width: object.width(:original),
      height: object.height(:original)
    }
  end

  def views(names: object.styles.keys)
    styles = object.styles.keys
    (names.map(&:to_sym) & styles).map do |style|
      {
        name: style,
        url: object.url(style),
        width: object.width(style),
        height: object.height(style)
      }
    end
  end
end
