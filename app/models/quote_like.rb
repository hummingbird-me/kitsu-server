class QuoteLike < ActiveRecord::Base
  belongs_to :quote, optional: false, counter_cache: :likes_count
  belongs_to :user, optional: false
end
