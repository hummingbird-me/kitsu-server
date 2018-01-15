class StatResource < BaseResource
  immutable
  caching

  include STIResource
  # STI, put all inheritance here
  model_hint model: Stat::AnimeCategoryBreakdown
  model_hint model: Stat::MangaCategoryBreakdown
  model_hint model: Stat::AnimeAmountConsumed
  model_hint model: Stat::MangaAmountConsumed
  model_hint model: Stat::AnimeFavoriteYear
  model_hint model: Stat::MangaFavoriteYear
  model_hint model: Stat::AnimeActivityHistory
  model_hint model: Stat::MangaActivityHistory

  has_one :user

  filters :user_id

  def stats_data
    _model.try(:enriched_stats_data) || _model.stats_data
  end
  attribute :stats_data
end
