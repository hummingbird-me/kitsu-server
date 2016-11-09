class BestowmentResource < BaseResource
  attributes :badge_id, :rank, :progress, :bestowed_at, :title,
    :description, :goal, :rarity, :users_have

  has_one :user
end
