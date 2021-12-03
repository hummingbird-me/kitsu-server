FactoryBot.define do
  factory :user do
    name { Faker::Internet.user_name(nil, ['_'])[0..15] + rand(1000).to_s }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :admin do
      permissions { [:admin] }
    end

    trait :banned do
      after(:create) { |user| user.add_role(:banned) }
    end

    trait :unregistered do
      status { :unregistered }
      password { nil }
      name { nil }
      email { nil }
    end

    trait :with_avatar do
      avatar { URI.open(Faker::Company.logo) }
    end

    trait :subscribed_to_one_signal do
      after(:create) do |user|
        create(:one_signal_player, user: user)
      end
    end
  end
end
