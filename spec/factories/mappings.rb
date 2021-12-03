FactoryBot.define do
  factory :mapping do
    association :item, factory: :anime, strategy: :build
    external_site { 'myanimelist' }
    external_id { rand(0..50_000) }
  end
end
