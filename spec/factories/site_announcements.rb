FactoryGirl.define do
  factory :site_announcement do
    association :user, strategy: :build
    text { Faker::Lorem.sentence }
    link { Faker::Internet.url }
  end
end
