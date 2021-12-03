FactoryBot.define do
  factory :streaming_link do
    association :media, factory: :anime, strategy: :build
    streamer
    url { Faker::Internet.url }
  end
end
