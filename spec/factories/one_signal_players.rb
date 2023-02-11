FactoryBot.define do
  factory :one_signal_player do
    association :user, factory: :user, strategy: :build
    player_id { Faker::Lorem.characters(number: 32) }
    platform { :web }
  end
end
