class Types::Input::Anime::Update < Types::Input::Base
  argument :id, ID, required: true

  argument :titles, Types::Input::TitlesList, required: false
  argument :synopsis, Types::Map, required: false
  argument :age_rating, Types::Enum::AgeRating, required: false
  argument :age_rating_guide, String, required: false
  argument :tba, String, required: false
  argument :start_date, Types::Date, required: false
  argument :end_date, Types::Date, required: false
  argument :poster_image, ApolloUploadServer::Upload, required: false
  argument :banner_image, ApolloUploadServer::Upload, required: false
  argument :youtube_trailer_video_id, String, required: false
  argument :episode_count, Integer, required: false
  argument :episode_length, Integer, required: false

  def to_model
    modified = {}
    if titles
      modified.merge!(
        titles: titles.localized,
        abbreviated_titles: titles.alternatives,
        canonical_title: titles.canonical_locale
      )
    end

    modified[:synopsis] = synopsis['en'] if synopsis
    modified[:cover_image] = banner_image if banner_image
    modified[:youtube_video_id] = youtube_trailer_video_id if youtube_trailer_video_id

    to_h.except(:banner_image, :youtube_trailer_video_id).merge(modified)
  end
end
