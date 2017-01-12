# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: profile_link_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :profile_link_site do
    name { Faker::Company.name }
    validate_find 'use trait'
    validate_replace 'use trait'

    # Twitter
    trait :twitter do
      validate_find '(https://)?(www.)?(twitter.com/)?(@)?(?<username>[a-z0-9_]+)'
      validate_replace "https://twitter.com/#{$username}"
    end

    # Facebook
    trait :facebook do
      validate_find '(https://)?(www.)?(facebook.com/)?(?<username>[a-z0-9_.]+)'
      validate_replace "https://facebook.com/#{$username}"
    end

    # Youtube
    trait :youtube do
      validate_find '(https://)?(www.)?(youtube.com/channel/)?(?<username>[A-Za-z0-9_\-]+)'
      validate_replace "https://youtube.com/channel/#{$username}"
    end
  end
end
