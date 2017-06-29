class BestowmentResource < BaseResource
  attributes :rank, :progress, :earned_at

  has_one :user
  has_one :badge
end
