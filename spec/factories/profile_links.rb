FactoryBot.define do
  factory :profile_link do
    association :user
    association :profile_link_site
    url { 'toyhammered' }
  end
end
