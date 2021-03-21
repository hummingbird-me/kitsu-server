FactoryBot.define do
  factory :site_announcement_view do
    association :announcement, factory: :site_announcement
    user
  end
end
