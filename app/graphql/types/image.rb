class Types::Image < Types::BaseObject
  field :original, Types::ImageView,
    null: false,
    description: 'The original image'

  def original
    case object
    when Paperclip::Attachment
      {
        name: 'original',
        url: object.url(:original),
        width: object.width(:original),
        height: object.height(:original)
      }
    when Shrine::Attacher
      {
        name: 'original',
        url: object.file.url,
        width: object.file.url,
        height: object.file.url
      }
    end
  end

  field :views, [Types::ImageView], null: false do
    description 'The various generated views of this image'
    argument :names, [String], required: false
  end

  def views(names: case object; when Paperclip::Attachment then object.styles.keys; when Shrine::Attacher then object.derivatives.keys; end)
    case object
    when Paperclip::Attachment
      styles = object.styles.keys
      (names.map(&:to_sym) & styles).map do |style|
        {
          name: style,
          url: object.url(style),
          width: object.width(style),
          height: object.height(style)
        }
      end
    when Shrine::Attacher
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
  end

  field :blurhash, String, null: true do
    description 'A blurhash-encoded version of this image'
  end

  def blurhash
    case object
    when Paperclip::Attachment then object.blurhash
    when Shrine::Attacher then object.file.blurhash
    end
  end
end
