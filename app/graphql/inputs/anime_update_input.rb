class Inputs::AnimeUpdateInput < Inputs::BaseInputObject
  argument :titles, Inputs::TitlesListInput, required: false
  argument :synopsis, Types::Map, required: false
  argument :age_rating, Types::AgeRating, required: false
  argument :age_rating_guide, String, required: false
  argument :tba, String, required: false
  argument :start_date, Types::Date, required: false
  argument :end_date, Types::Date, required: false
  argument :poster_image, ApolloUploadServer::Upload, required: false
  argument :banner_image, ApolloUploadServer::Upload, required: false
  argument :youtube_video_id, String, required: false
  argument :episode_count, Integer, required: false
  argument :episode_length, Integer, required: false

  def to_model
    modified = {}
    if titles
      modified.merge!(
        titles: titles.localized,
        abbreviated_titles: titles.alternatives,
        canonical_title: titles.canonical_key
      )
    end

    modified[:synopsis] = synopsis['en'] if synopsis
    modified[:cover_image] = banner_image if banner_image

    to_h.except(:banner_image).merge(modified)
  end
end
