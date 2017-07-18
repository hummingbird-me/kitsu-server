# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_ignores
#
#  id         :integer          not null, primary key
#  media_type :string           indexed => [media_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  media_id   :integer          indexed => [media_type]
#  user_id    :integer          indexed
#
# Indexes
#
#  index_media_ignores_on_media_type_and_media_id  (media_type,media_id)
#  index_media_ignores_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_ce29fae9fe  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :media_ignore do
    association :media, factory: :anime, strategy: :build
    association :user, factory: :user, strategy: :build
  end
end
