require 'rails_helper'

RSpec.describe Anime, type: :model do
  subject { build(:anime) }

  include_examples 'media'
  include_examples 'episodic'
  include_examples 'age_ratings'

  it { is_expected.to have_many(:anime_characters).dependent(:destroy) }
  it { is_expected.to have_many(:anime_staff).dependent(:destroy) }
  it { is_expected.to have_many(:anime_productions).dependent(:destroy) }

  describe '#season' do
    it 'returns winter for shows starting in December through February' do
      dec_anime = build(:anime, start_date: Date.new(2015, 12))
      jan_anime = build(:anime, start_date: Date.new(2016, 1))
      feb_anime = build(:anime, start_date: Date.new(2016, 2))
      expect(dec_anime.season).to eq(:winter)
      expect(jan_anime.season).to eq(:winter)
      expect(feb_anime.season).to eq(:winter)
    end

    it 'returns spring for shows starting in March through May' do
      mar_anime = build(:anime, start_date: Date.new(2016, 3))
      apr_anime = build(:anime, start_date: Date.new(2016, 4))
      may_anime = build(:anime, start_date: Date.new(2016, 5))
      expect(mar_anime.season).to eq(:spring)
      expect(apr_anime.season).to eq(:spring)
      expect(may_anime.season).to eq(:spring)
    end

    it 'returns summer for shows starting in June through August' do
      jun_anime = build(:anime, start_date: Date.new(2016, 6))
      jul_anime = build(:anime, start_date: Date.new(2016, 7))
      aug_anime = build(:anime, start_date: Date.new(2016, 8))
      expect(jun_anime.season).to eq(:summer)
      expect(jul_anime.season).to eq(:summer)
      expect(aug_anime.season).to eq(:summer)
    end

    it 'returns fall for shows starting in September through November' do
      sep_anime = build(:anime, start_date: Date.new(2016, 9))
      oct_anime = build(:anime, start_date: Date.new(2016, 10))
      nov_anime = build(:anime, start_date: Date.new(2016, 11))
      expect(sep_anime.season).to eq(:fall)
      expect(oct_anime.season).to eq(:fall)
      expect(nov_anime.season).to eq(:fall)
    end
  end

  describe 'sync_episodes' do
    it 'creates episodes when episode_count is changed' do
      create(:anime, episode_count: 5)
      anime = Anime.last
      expect(anime.episodes.length).to eq(anime.episode_count)
    end
  end
end
