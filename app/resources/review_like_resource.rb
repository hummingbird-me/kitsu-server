class ReviewLikeResource < BaseResource
  has_one :review
  has_one :user
end
