FactoryBot.define do
  factory :pro_membership_plan do
    recurring { [true, false].sample }
    duration { 1 + rand(35) }
    amount { 500 + rand(9500) }
    name { Faker::App.name }

    factory :nonrecurring_pro_membership_plan do
      recurring { false }
    end
    factory :recurring_pro_membership_plan do
      recurring { true }
    end
  end
end
