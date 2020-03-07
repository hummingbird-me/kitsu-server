class Inputs::AnimeCreateInput < Inputs::BaseInputObject
  argument :titles, Inputs::TitlesListInput, required: true
  argument :synopsis, Types::Map, required: true
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
    modified = { 
      titles: self.titles.localized,
      abbreviated_titles: self.titles.alternatives,
      canonical_title: self.titles.canonical_key,
      synopsis: self.synopsis['en']
    }

    modified[:cover_image] = self.banner_image if self.banner_image

    self.to_h.except(:banner_image).merge(modified)
  end
end
