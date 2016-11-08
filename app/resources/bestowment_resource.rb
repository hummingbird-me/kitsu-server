class BestowmentResource < BaseResource
  attributes :badge_id, :rank, :progress, :bestowed_at

  has_one :user
end
