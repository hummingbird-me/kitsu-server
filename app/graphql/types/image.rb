class Types::Image < Types::BaseObject
  field :original, Types::ImageView,
    null: false,
    description: 'The original image'

  def original
    return nil unless object.file
    {
      name: 'original',
      url: object.file.url,
      width: object.file.url,
      height: object.file.url
    }
  end

  field :views, [Types::ImageView], null: false do
    description 'The various generated views of this image'
    argument :names, [String], required: false
  end

  def views(names: object.derivatives.keys)
    derivatives = object.derivatives
    (names.map(&:to_sym) & derivatives.keys).map do |name|
      {
        name: name,
        url: derivatives[name].url,
        width: derivatives[name].width,
        height: derivatives[name].height
      }
    end
  end

  field :blurhash, String, null: true do
    description 'A blurhash-encoded version of this image'
  end

  def blurhash
    object.file.blurhash
  end
end
