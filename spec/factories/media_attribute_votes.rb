# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_attribute_votes
#
#  id                         :integer          not null, primary key
#  media_type                 :string           not null, indexed => [user_id, media_id]
#  vote                       :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  anime_media_attributes_id  :integer
#  dramas_media_attributes_id :integer
#  manga_media_attributes_id  :integer
#  media_id                   :integer          not null, indexed => [user_id, media_type]
#  user_id                    :integer          not null, indexed, indexed => [media_id, media_type]
#
# Indexes
#
#  index_media_attribute_votes_on_user_id  (user_id)
#  index_user_media_on_media_attr_votes    (user_id,media_id,media_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_39b0c09be9  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :media_attribute_vote do
    vote 1
    user
    association :anime_media_attributes, factory: :anime_media_attribute,
                                         strategy: :build
  end
end
