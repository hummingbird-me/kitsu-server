class Types::Input::Manga::Create < Types::Input::Base
  argument :titles, Inputs::TitlesListInput, required: true
  argument :synopsis, Types::Map, required: true
  argument :subtype, Types::Enum::MangaSubtype, required: true

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
    modified = {
      titles: titles.localized,
      abbreviated_titles: titles.alternatives,
      canonical_title: titles.canonical_locale,
      synopsis: synopsis['en']
    }

    modified[:cover_image] = banner_image if banner_image

    to_h.except(:banner_image).merge(modified)
  end
end
