class FavoriteResource < BaseResource
  include RankedResource

  attributes :fav_rank
  ranks :fav_rank

  has_one :user
  has_one :item, polymorphic: true

  filters :user_id, :item_type, :item_id
end
