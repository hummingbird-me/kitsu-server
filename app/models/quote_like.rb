class QuoteLike < ActiveRecord::Base
  belongs_to :quote, required: true, counter_cache: :likes_count
  belongs_to :user, required: true
end
