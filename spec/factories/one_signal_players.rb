FactoryBot.define do
  factory :one_signal_player do
    association :user, factory: :user, strategy: :build
    player_id { Faker::Lorem.characters(32) }
    platform { :web }
  end
end
