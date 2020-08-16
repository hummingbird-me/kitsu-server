class Types::Input::Manga::Update < Types::Input::Base
  argument :id, ID, required: true

  argument :titles, Types::Input::TitlesList, required: false
  argument :description, Types::Map, required: false
  argument :subtype, Types::Enum::MangaSubtype, required: false
  argument :age_rating, Types::Enum::AgeRating, required: false
  argument :age_rating_guide, String, required: false
  argument :tba, String, required: false
  argument :start_date, Types::Date, required: false
  argument :end_date, Types::Date, required: false
  argument :poster_image, ApolloUploadServer::Upload, required: false
  argument :banner_image, ApolloUploadServer::Upload, required: false
  argument :chapter_count, Integer, required: false
  argument :chapter_count_guess, Integer, required: false
  argument :volume_count, Integer, required: false
  argument :original_locale, String, required: false

  def to_model
    modified = {}
    if titles
      modified.merge!(
        titles: titles.localized,
        abbreviated_titles: titles.alternatives,
        canonical_title: titles.canonical_locale
      )
    end

    modified[:description].merge!(description) if description
    modified[:cover_image] = banner_image if banner_image

    to_h.except(:banner_image).merge(modified)
  end
end
