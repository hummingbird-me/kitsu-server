FactoryBot.define do
  factory :streamer do
    site_name { Faker::Company.name }
  end
end
