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

FactoryGirl.define do
  factory :favorite do
    association :item, factory: :anime, strategy: :build
    user
  end
end
