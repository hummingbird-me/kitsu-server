module EpisodicResource
  extend ActiveSupport::Concern

  included do
    attributes :episode_count, :episode_length, :total_length

    query :episode_count, MediaResource::NUMERIC_QUERY
    query :episode_length, MediaResource::NUMERIC_QUERY

    has_many :episodes
  end

  def episode_length
    _model.episode_length / 60 if _model.episode_length
  end

  def total_length
    _model.total_length / 60 if _model.total_length
  end
end
