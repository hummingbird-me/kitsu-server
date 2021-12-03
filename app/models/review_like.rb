class ReviewLike < ApplicationRecord
  belongs_to :review, required: true, counter_cache: :likes_count
  belongs_to :user, required: true
end
