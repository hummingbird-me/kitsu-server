# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  fav_rank   :integer          default(9999), not null
#  item_type  :string(255)      not null, indexed => [item_id], indexed => [user_id, item_id], indexed => [user_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          not null, indexed => [item_type], indexed => [user_id, item_type]
#  user_id    :integer          not null, indexed, indexed => [item_id, item_type], indexed => [item_type]
#
# Indexes
#
#  index_favorites_on_item_id_and_item_type              (item_id,item_type)
#  index_favorites_on_user_id                            (user_id)
#  index_favorites_on_user_id_and_item_id_and_item_type  (user_id,item_id,item_type) UNIQUE
#  index_favorites_on_user_id_and_item_type              (user_id,item_type)
#
# rubocop:enable Metrics/LineLength

class Favorite < ApplicationRecord
  has_paper_trail
  acts_as_list column: 'fav_rank', scope: %i[user_id item_type]

  belongs_to :user, required: true, counter_cache: true
  belongs_to :item, polymorphic: true, required: true

  validates :item, polymorphism: { type: [Media, Character, Person] }
  validates :user_id, uniqueness: {
    scope: %i[item_type item_id],
    message: 'Cannot fave a media multiple times'
  }

  after_create { user.update_profile_completed! }
end
