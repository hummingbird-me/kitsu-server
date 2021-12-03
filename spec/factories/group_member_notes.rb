FactoryBot.define do
  factory :group_member_note do
    association :user, strategy: :build
    association :group_member, strategy: :build
    content { Faker::Lorem.sentence }
  end
end
