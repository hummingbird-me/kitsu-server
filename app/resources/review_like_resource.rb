class ReviewLikeResource < BaseResource
  has_one :review
  has_one :user

  filters :review_id, :user_id
end
