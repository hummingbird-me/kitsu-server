FactoryBot.define do
  factory :group_invite do
    before(:create) do |_invite, evaluator|
      Follow.create!(follower: evaluator.user, followed: evaluator.sender)
    end

    group
    user
    association :sender, factory: :user
  end
end
