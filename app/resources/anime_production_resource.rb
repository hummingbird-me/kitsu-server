class AnimeProductionResource < BaseResource
  attribute :role
  has_one :anime
  has_one :producer

  filter :role, :anime_id, :producer_id
end
