# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: profile_link_sites
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  validate_find    :string
#  validate_replace :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :profile_link_site do
    name { Faker::Company.name }
    validate_find '\A(https?://)?(www.)?(twitter.com/)?(@)?(?<username>[a-zA-Z0-9_]+)\z'
    validate_replace 'https://twitter.com/\k<username>'

    # Twitter
    trait :twitter do
      validate_find '\A(https?://)?(www.)?(twitter.com/)?(@)?(?<username>[a-zA-Z0-9_]+)\z'
      validate_replace 'https://twitter.com/\k<username>'
    end

    # Facebook
    trait :facebook do
      validate_find '\A(https?://)?(www.)?(facebook.com/)?(?<username>[a-zA-Z0-9_.]+)\z'
      validate_replace 'https://facebook.com/\k<username>'
    end

    # Youtube
    trait :youtube do
      validate_find '\A(https?://)?(www.)?(youtube.com/)?(?<channel>user|c|channel)?/?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://youtube.com/\k<channel>/\k<username>'
    end

    # Google
    trait :google do
      validate_find '\A(https?://)?(www.)?(plus.google.com/)?(?<username>.+)\z'
      validate_replace 'https://plus.google.com/\k<username>'
    end

    # Instagram
    trait :instagram do
      validate_find '\A(https?://)?(www.)?(instagram.com/)?(?<username>[a-zA-Z0-9_.]+)\z'
      validate_replace 'https://instagram.com/\k<username>'
    end

    # Twitch
    trait :twitch do
      validate_find '\A(https?://)?(www.)?(twitch.tv/)?(#)?(?<username>[a-zA-Z0-9_]+)\z'
      validate_replace 'https://twitch.tv/\k<username>'
    end

    # Vimeo
    trait :vimeo do
      validate_find '\A(https?://)?(www.)?(vimeo.com/)?(?<username>[a-zA-Z0-9_\-]+)\z'
      validate_replace 'https://vimeo.com/\k<username>'
    end

    # Github
    trait :github do
      validate_find '\A(https?://)?(www.)?(github.com/)?@?(?<username>[a-zA-Z0-9\-]+)\z'
      validate_replace 'https://github.com/\k<username>'
    end

    # Battlenet
    trait :battlenet do
      validate_find '\A(.+#[0-9]+)\z'
      validate_replace '\1'
    end

    # Steam
    trait :steam do
      validate_find '\A(https?://)?(www.)?(steamcommunity.com/id/)?(?<username>[a-zA-Z0-9_\-]+)\z'
      validate_replace 'http://steamcommunity.com/id/\k<username>'
    end

    # Raptr
    trait :raptr do
      validate_find '\A(https?://)?(www.)?(raptr.com/)?(?<username>[a-zA-Z0-9_\-]+)\z'
      validate_replace 'http://raptr.com/\k<username>'
    end

    # Discord
    trait :discord do
      validate_find '\A(.+#[0-9]+)\z'
      validate_replace '\1'
    end

    # Tumblr
    trait :tumblr do
      validate_find '\A(https?://)?(www.)?(?<username>[a-zA-Z0-9_\-]+)(.tumblr.com)?\z'
      validate_replace '\k<username>.tumblr.com'
    end

    # SoundCloud
    trait :soundcloud do
      validate_find '\A(https?://)?(www.)?(soundcloud.com/)?(?<username>[a-zA-Z0-9]+)\z'
      validate_replace 'https://soundcloud.com/\k<username>'
    end

    # DailyMotion
    trait :dailymotion do
      validate_find '\A(https?://)?(www.)?(dailymotion.com/)?(?<username>[a-zA-Z0-9_\-]+)\z'
      validate_replace 'https://dailymotion.com/\k<username>'
    end

    # Kickstarter
    trait :kickstarter do
      validate_find '\A(https?://)?(www.)?(kickstarter.com/profile/)?(?<username>[a-zA-Z0-9_.\-]+)\z'
      validate_replace 'https://kickstarter.com/profile/\k<username>'
    end

    # Mobcrush
    trait :mobcrush do
      validate_find '\A(https?://)?(www.)?(mobcrush.com/)?(?<username>[a-zA-Z0-9_\-]+)\z'
      validate_replace 'https://mobcrush.com/\k<username>'
    end

    # Osu!
    trait :osu do
      validate_find '\A(https?://)?(www.)?(osu.ppy.sh/u/)?(?<username>[0-9]+)\z'
      validate_replace 'https://osu.ppy.sh/u/\k<username>'
    end

    # Patreon
    trait :patreon do
      validate_find '\A(https?://)?(www.)?(patreon.com/)?(?<username>[a-zA-Z0-9_\-]+)\z'
      validate_replace 'https://patreon.com/\k<username>'
    end

    # DeviantArt
    trait :deviantart do
      validate_find '\A(https?://)?(www.)?(?<username>[a-zA-z0-9_\-]+)(.deviantart.com)?\z'
      validate_replace 'https://\k<username>.deviantart.com'
    end

    # Dribbble
    trait :dribbble do
      validate_find '\A(https?://)?(www.)?(dribbble.com/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://dribbble.com/\k<username>'
    end

    # IMDb
    trait :imdb do
      validate_find '\A(https?://)?(www.)?(imdb.com/)?(user/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://www.imdb.com/user/\k<username>'
    end

    # Last.fm
    trait :lastfm do
      validate_find '\A(https?://)?(www.)?(last.fm/)?(user/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://last.fm/user/\k<username>'
    end

    # Letterboxd
    trait :letterboxd do
      validate_find '\A(https?://)?(www.)?(letterboxd.com/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://letterboxd.com/\k<username>'
    end

    # Medium
    trait :medium do
      validate_find '\A(https?://)?(www.)?(medium.com/)?(?<username>[a-zA-Z0-9@_\-]+)\z'
      validate_replace 'https://medium.com/\k<username>'
    end

    # Player.me
    trait :playerme do
      validate_find '\A(https?://)?(www.)?(player.me/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://player.me/\k<username>'
    end

    # Reddit
    trait :reddit do
      validate_find '\A(https?://)?(www.)?(reddit.com/)?(user/|u/)?(/u/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://reddit.com/user/\k<username>'
    end

    # Trakt
    trait :trakt do
      validate_find '\A(https?://)?(www.)?(trakt.tv/)?(users/)?(?<username>[a-zA-z0-9_\-]+)\z'
      validate_replace 'https://trakt.tv/users/\k<username>'
    end

    # Website
    trait :website do
      validate_find '(?<protocol>https?://)(www.)?(?<url>(.)+\.(.)+)'
      validate_replace '\k<protocol\k<url>'
    end
    # rubocop:enable Metrics/LineLength
  end
end
