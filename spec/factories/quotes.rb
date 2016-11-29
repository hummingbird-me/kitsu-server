# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: quotes
#
#  id             :integer          not null, primary key
#  character_name :string(255)
#  content        :text             not null
#  likes_count    :integer          default(0), not null
#  media_type     :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  character_id   :integer          not null
#  media_id       :integer          not null, indexed
#  user_id        :integer          not null
#
# Indexes
#
#  index_quotes_on_media_id  (media_id)
#
# Foreign Keys
#
#  fk_rails_02b555fb4d  (user_id => users.id)
#  fk_rails_3a2ddd4b36  (media_id => anime.id)
#  fk_rails_bd0c2ee7f3  (character_id => characters.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :quote do
    association :user, factory: :user, strategy: :build
    association :media, factory: :anime, strategy: :build
    association :character, factory: :character, strategy: :build

    content { Faker::Lorem.sentence }
  end
end
