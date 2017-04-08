# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_categories
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :group_category do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end
