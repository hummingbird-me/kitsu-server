FactoryGirl.define do
  factory :stat do
    association :user, factory: :user, strategy: :build
    type 'Stat::AnimeGenreBreakdown'
  end
end
