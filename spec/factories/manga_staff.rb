FactoryBot.define do
  factory :manga_staff do
    association :manga, factory: :manga, strategy: :build
    association :person, factory: :person, strategy: :build
  end
end
