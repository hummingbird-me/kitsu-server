# == Schema Information
#
# Table name: profile_link_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProfileLinkSite, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:validate_find) }
  it { should validate_presence_of(:validate_replace) }

  context 'validate profile_link url' do
    describe 'twitter' do
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
            Regexp.new(site.validate_find) =~ url
            expect($1).to eq("toyhammered")
          end
        end
      end
    end

    describe 'facebook' do
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
            Regexp.new(site.validate_find) =~ url
            expect($1).to eq("toyhammered")
          end
        end

        it 'should allow usernames with a "."' do
          urls = %w[
            facebook.com/toy.hammered
            toy.hammered
          ]
          site = build(:profile_link_site, :facebook)

          urls.each do |url|
            Regexp.new(site.validate_find) =~ url
            expect($1).to eq("toy.hammered")
          end
        end
      end
    end

    describe 'youtube' do
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
            Regexp.new(site.validate_find) =~ url
            expect($1).to eq("UC_-Zt4dWU1bT52tG-DHGftg")
          end
        end
      end
    end
  end # end of validate context
end
