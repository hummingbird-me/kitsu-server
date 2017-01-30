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

    # rubocop:disable Metrics/LineLength
    # Twitter
    trait :twitter do
      validate_find '(https://)?(www.)?(twitter.com/)?(@)?(?<username>[a-zA-Z0-9_]+)'
      validate_replace 'https://twitter.com/\k<username>'
    end

    # Facebook
    trait :facebook do
      validate_find '(https://)?(www.)?(facebook.com/)?(?<username>[a-zA-z0-9_.]+)'
      validate_replace 'https://facebook.com/\k<username>'
    end

    # Youtube
    trait :youtube do
      validate_find '(https://)?(www.)?(youtube.com/channel/)?(?<username>[a-zA-z0-9_\-]+)'
      validate_replace 'https://youtube.com/channel/\k<username>'
    end

    # Google
    trait :google do
      validate_find '(https://)?(www.)?(plus.google.com/)?(?<username>[.]+)'
      validate_replace 'https://plus.google.com/\k<username>'
    end

    # Instagram
    trait :instagram do
      validate_find '(https://)?(www.)?(instagram.com/)?(?<username>[a-zA-z0-9_.]+)'
      validate_replace 'https://www.instagram.com/\k<username>'
    end

    # Twitch
    trait :twitch do
      validate_find '(https://)?(www.)?(twitch.tv/)?(#)?(?<username>[a-zA-z0-9_]+)'
      validate_replace 'https://www.twitch.tv/\k<username>'
    end

    # Vimeo
    trait :vimeo do
      validate_find '(https://)?(www.)?(vimeo.com/)?(?<username>[a-zA-z0-9_\-]+)'
      validate_replace 'https://vimeo.com/\k<username>'
    end

    # Github
    trait :github do
      validate_find '(https://)?(www.)?(github.com/)?@?(?<username>[a-zA-z0-9\-]+)'
      validate_replace 'https://github.com/\k<username>'
    end

    # Battlenet
    trait :battlenet do
      validate_find 'will figure out'
      validate_replace 'will figure out'
    end

    # Steam
    trait :steam do
      validate_find '((http|https)://)?(www.)?(steamcommunity.com/id/)?(?<username>[a-zA-z0-9_\-]+)'
      validate_replace 'http://steamcommunity.com/id/\k<username>'
    end

    # Raptr
    trait :raptr do
      validate_find '((http|https)://)?(www.)?(raptr.com/)?(?<username>[a-zA-z0-9_\-]+)'
      validate_replace 'http://raptr.com/\k<username>'
    end

    # Discord
    trait :discord do
      validate_find '([.]+#[0-9]+)'
      validate_replace '\1'
    end

    # Tumblr
    trait :tumblr do
      validate_find 'will figure out'
      validate_replace 'will figure out'
    end

    # SoundCloud
    trait :soundcloud do
      validate_find '(https://)?(www.)?(soundcloud.com/)?(?<username>[a-zA-z0-9]+)'
      validate_replace 'https://soundcloud.com/\k<username>'
    end

    # DailyMotion
    trait :dailymotion do
      validate_find '(https://)?(www.)?(dailymotion.com/)?(?<username>[a-zA-z0-9_\-]+)'
      validate_replace 'https://dailymotion.com/\k<username>'
    end

    # Kickstarter will go here
    trait :kickstarter do
      validate_find '(https://)?(www.)?(kickstarter.com/profile/)?(?<username>[a-zA-z0-9_.\-]+)'
      validate_replace 'https://www.kickstarter.com/profile/\k<username>'
    end

    # Mobcrush
    trait :mobcrush do
      validate_find '(https://)?(www.)?(mobcrush.com/)?(?<username>[a-zA-z0-9_\-]+)'
      validate_replace 'https://mobcrush.com/\k<username>'
    end

    # Osu!
    trait :osu do
      validate_find '(https://)?(www.)?(osu.ppy.sh/u/)?(?<username>[0-9]+)'
      validate_replace 'https://osu.ppy.sh/u/\k<username>'
    end

    # Patreon
    trait :patreon do
      validate_find 'will figure out'
      validate_replace 'will figure out'
    end
    # rubocop:enable Metrics/LineLength
  end
end
