class Types::Input::Episode::Create < Types::Input::Base
  argument :media_id, ID, required: true
  argument :media_type, Types::Enum::MediaType, required: true
  argument :titles, Types::Input::TitlesList, required: true
  argument :number, Integer, required: true

  argument :description, Types::Map, required: false
  argument :length, Integer, required: false
  argument :aired_at, Types::Date, required: false
  argument :thumbnail_image, ApolloUploadServer::Upload, required: false

  def to_model
    modified = {
      titles: titles.localized,
      canonical_title: titles.canonical_locale
    }

    modified[:thumbnail] = thumbnail_image if thumbnail_image.present?

    to_h.except(:thumbnail_image).merge(modified)
  end
end
