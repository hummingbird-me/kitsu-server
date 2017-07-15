class StatResource < BaseResource
  immutable

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

  attribute :stats_data
  # kind is aliased to type

  has_one :user

  filters :user_id
end
