class StatResource < BaseResource
  # STI, put all inheritance here
  model_hint model: Stat::AnimeGenreBreakdown
  model_hint model: Stat::AnimeAmountWatched

  attributes :stats_data, :kind
  # kind is aliased to type

  has_one :user

  filters :user_id
end
