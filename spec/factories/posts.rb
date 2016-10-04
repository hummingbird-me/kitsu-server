FactoryGirl.define do
  factory :post do
    user
    text { Faker::Lorem.sentence }
  end
end
