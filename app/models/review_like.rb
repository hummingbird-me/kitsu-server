class ReviewLike < ApplicationRecord
  belongs_to :review, optional: false, counter_cache: :likes_count
  belongs_to :user, optional: false
end
