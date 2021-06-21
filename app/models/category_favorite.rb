# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: category_favorites
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer          indexed
#  user_id     :integer          not null, indexed
#
# Indexes
#
#  index_category_favorites_on_category_id  (category_id)
#  index_category_favorites_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_146a35d9c5  (user_id => users.id)
#  fk_rails_e879bc7c3b  (category_id => categories.id)
#
# rubocop:enable Metrics/LineLength

class CategoryFavorite < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :category, required: true

  validates :user_id, uniqueness: {
    scope: :category_id,
    message: 'Cannot fave a category multiple times'
  }
end
