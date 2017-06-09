# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_attributes
#
#  id            :integer          not null, primary key
#  high_title    :string           not null
#  low_title     :string           not null
#  neutral_title :string           not null
#  slug          :string           not null, indexed
#  title         :string           not null, indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_media_attributes_on_slug   (slug)
#  index_media_attributes_on_title  (title)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :media_attribute do
    title { Faker::Name.name }
    high_title { Faker::Name.name }
    neutral_title { Faker::Name.name }
    low_title { Faker::Name.name }
  end
end
