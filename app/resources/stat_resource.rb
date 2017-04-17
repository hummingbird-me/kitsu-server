class StatResource < BaseResource
  immutable

  include STIResource
  # STI, put all inheritance here
  model_hint model: Stat::AnimeGenreBreakdown
  model_hint model: Stat::MangaGenreBreakdown
  model_hint model: Stat::AnimeAmountConsumed
  model_hint model: Stat::MangaAmountConsumed

  attribute :stats_data
  # kind is aliased to type

  has_one :user

  filters :user_id
end
