FactoryBot.define do
  factory :media_attribute_vote do
    vote { 1 }
    user
    association :anime_media_attributes, factory: :anime_media_attribute,
      strategy: :create
  end
end
