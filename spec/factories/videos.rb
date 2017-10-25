FactoryGirl.define do
  factory :video do
    url { Faker::Internet.url }
    association :episode, factory: :episode, strategy: :build
    association :streamer, factory: :streamer, strategy: :build
    sub_lang 'en'
    dub_lang 'ja'
  end
end
