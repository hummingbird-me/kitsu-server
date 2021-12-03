FactoryBot.define do
  factory :anime_casting do
    locale { 'en' }
    association :anime_character, factory: :anime_character, strategy: :build
    association :person, factory: :person, strategy: :build
  end
end
