FactoryBot.define do
  factory :drama_casting do
    locale { 'en' }
    association :drama_character, factory: :drama_character
    association :person, factory: :person
  end
end
