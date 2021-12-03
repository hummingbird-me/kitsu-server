FactoryBot.define do
  factory :user_ip_address do
    user
    ip_address { Faker::Internet.ip_v4_address }
  end
end
