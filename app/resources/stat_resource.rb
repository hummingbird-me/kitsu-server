class StatResource < BaseResource
  include STIResource
  # STI, put all inheritance here
  model_hint model: Stat::AnimeGenreBreakdown
  model_hint model: Stat::AnimeAmountWatched

  attribute :stats_data
  # kind is aliased to type

  has_one :user

  filters :user_id
end
