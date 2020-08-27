class Types::Input::Episode::Update < Types::Input::Base
  argument :id, ID, required: true

  argument :titles, Types::Input::TitlesList, required: false
  argument :number, Integer, required: false
  argument :description, Types::Map, required: false
  argument :length, Integer, required: false
  argument :released_at, Types::Date, required: false, as: :airdate
  argument :thumbnail_image, ApolloUploadServer::Upload, required: false

  def to_model
    modified = {}

    if titles
      modified.merge(
        titles: titles.localized,
        canonical_title: titles.canonical_locale
      )
    end

    modified[:thumbnail] = thumbnail_image if thumbnail_image.present?

    to_h.except(:thumbnail_image).merge(modified)
  end
end
