FactoryGirl.define do
  factory :comment do
    user
    post
    text { Faker::Lorem.sentence }
  end
end
