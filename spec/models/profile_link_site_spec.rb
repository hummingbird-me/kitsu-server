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

require 'rails_helper'

RSpec.describe ProfileLinkSite, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:validate_find) }
  it { should validate_presence_of(:validate_replace) }

  context 'validate profile_link url' do
    # Twitter
    describe 'Twitter' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            twitter.com/@toyhammered
            https://www.twitter.com/@toyhammered
            https://twitter.com/@toyhammered
            https://twitter.com/toyhammered
            @toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :twitter)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Facebook
    describe 'Facebook' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            facebook.com/toyhammered
            https://www.facebook.com/toyhammered
            https://facebook.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :facebook)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Youtube
    describe 'Youtube' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            youtube.com/channel/UC_-Zt4dWU1bT52tG-DHGftg
            https://www.youtube.com/channel/UC_-Zt4dWU1bT52tG-DHGftg
            https://youtube.com/channel/UC_-Zt4dWU1bT52tG-DHGftg
            UC_-Zt4dWU1bT52tG-DHGftg
          ]
          site = build(:profile_link_site, :youtube)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('UC_-Zt4dWU1bT52tG-DHGftg')
          end
        end
      end
    end

    # TODO: figure out how to deal with custom url (having +)
    # Google+
    describe 'Google+' do
      context 'success' do
        it 'should work without custom url' do
          urls = %w[
            https://plus.google.com/115819863396302953172
            plus.google.com/115819863396302953172
            115819863396302953172
          ]
          site = build(:profile_link_site, :google)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('115819863396302953172')
          end
        end
        it 'should work with custom url' do
          urls = %w[
            https://plus.google.com/+toyhammered
            plus.google.com/+toyhammered
            +toyhammered
          ]
          site = build(:profile_link_site, :google)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('+toyhammered')
          end
        end
      end
    end

    # Instagram
    describe 'Instagram' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            instagram.com/rassiner
            https://www.instagram.com/rassiner
            https://instagram.com/rassiner
            rassiner
          ]
          site = build(:profile_link_site, :instagram)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('rassiner')
          end
        end
      end
    end

    # Twitch
    describe 'Twitch' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            twitch.tv/toyhammered
            https://www.twitch.tv/toyhammered
            https://www.twitch.tv/#toyhammered
            https://twitch.tv/toyhammered
            toyhammered
            #toyhammered
          ]
          site = build(:profile_link_site, :twitch)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Vimeo
    describe 'Vimeo' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            vimeo.com/toyhammered
            https://www.vimeo.com/toyhammered
            https://vimeo.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :vimeo)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Github
    describe 'Github' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            github.com/toyhammered
            https://www.github.com/toyhammered
            https://www.github.com/@toyhammered
            https://github.com/toyhammered
            toyhammered
            @toyhammered
          ]
          site = build(:profile_link_site, :github)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Battlenet
    describe 'Battlenet' do
      context 'success' do
        it 'should return a username' do
          url = 'toyhammered#0718'
          site = build(:profile_link_site, :discord)

          temp = site.validate_find.match(url)
          expect(temp[1]).to eq('toyhammered#0718')
        end
      end
    end

    # Steam
    describe 'Steam' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            steamcommunity.com/id/toyhammered
            http://steamcommunity.com/id/toyhammered
            https://steamcommunity.com/id/toyhammered
            http://www.steamcommunity.com/id/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :steam)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Raptr
    describe 'Raptr' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            raptr.com/toyhammered
            http://raptr.com/toyhammered
            https://raptr.com/toyhammered
            http://www.raptr.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :raptr)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Discord
    describe 'Discord' do
      context 'success' do
        it 'should return a username' do
          url = 'toyhammered#0718'
          site = build(:profile_link_site, :discord)

          temp = site.validate_find.match(url)
          expect(temp[1]).to eq('toyhammered#0718')
        end
      end
    end

    # Tumblr
    describe 'tumblr' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            https://toyhammered.tumblr.com
            http://toyhammered.tumblr.com
            https://www.toyhammered.tumblr.com
            www.toyhammered.tumblr.com
            toyhammered.tumblr.com
            toyhammered
          ]
          site = build(:profile_link_site, :tumblr)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # SoundCloud
    describe 'soundcloud' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            soundcloud.com/toyhammered
            https://www.soundcloud.com/toyhammered
            https://soundcloud.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :soundcloud)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Dailymotion
    describe 'Dailymotion' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            dailymotion.com/toyhammered
            https://www.dailymotion.com/toyhammered
            https://dailymotion.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :dailymotion)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Kickstarter
    describe 'Kickstarter' do
      context 'success' do
        it 'should work with a custom username' do
          urls = %w[
            kickstarter.com/profile/toyhammered
            https://www.kickstarter.com/profile/toyhammered
            https://kickstarter.com/profile/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :kickstarter)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
        it 'should work with a non-custom username' do
          urls = %w[
            kickstarter.com/profile/111759513
            https://www.kickstarter.com/profile/111759513
            https://kickstarter.com/profile/111759513
            111759513
          ]
          site = build(:profile_link_site, :kickstarter)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('111759513')
          end
        end
      end
    end

    # Mobcrush
    describe 'Mobcrush' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            mobcrush.com/toyhammered
            https://www.mobcrush.com/toyhammered
            https://mobcrush.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :mobcrush)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end

    # Osu!
    describe 'Osu!' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            https://osu.ppy.sh/u/1234567
            https://www.osu.ppy.sh/u/1234567
            osu.ppy.sh/u/1234567
            1234567
          ]
          site = build(:profile_link_site, :osu)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('1234567')
          end
        end
      end
    end

    # Patreon
    describe 'Patreon' do
      context 'success' do
        it 'should return a username' do
          urls = %w[
            patreon.com/toyhammered
            https://www.patreon.com/toyhammered
            https://patreon.com/toyhammered
            toyhammered
          ]
          site = build(:profile_link_site, :patreon)

          urls.each do |url|
            temp = site.validate_find.match(url)
            expect(temp[:username]).to eq('toyhammered')
          end
        end
      end
    end
  end # end of validate context
end
