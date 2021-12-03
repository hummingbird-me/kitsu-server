FactoryBot.define do
  factory :linked_account do
    association :user
    external_user_id { 'toyhammered' }
    token { 'fakefake' }
    type { 'LinkedAccount::MyAnimeList' }
  end
end
