# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: one_signal_players
#
#  id         :integer          not null, primary key
#  platform   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :string
#  user_id    :integer          indexed
#
# Indexes
#
#  index_one_signal_players_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_9384bbcdb2  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :one_signal_player do
    association :user, factory: :user, strategy: :build
    player_id { Faker::Lorem.characters(32) }
    platform :web
  end
end
