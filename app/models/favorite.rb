class Favorite < ApplicationRecord
  include RankedModel
  ranks :fav_rank, with_same: %i[user_id item_type]

  belongs_to :user, required: true, counter_cache: true
  belongs_to :item, polymorphic: true, required: true

  validates :item, polymorphism: { type: [Media, Character, Person] }
  validates :user_id, uniqueness: {
    scope: %i[item_type item_id],
    message: 'Cannot fave a media multiple times'
  }

  after_create { user.update_profile_completed! }
end
