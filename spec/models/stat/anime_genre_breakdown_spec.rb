require 'rails_helper'

RSpec.describe Stat::AnimeGenreBreakdown do
  let(:user) { create(:user) }
  subject { build(:stat, user: user).becomes(Stat::AnimeGenreBreakdown) }

  let(:anime) { create(:anime, :genres) }
  let!(:le) { create(:library_entry, user: user, anime: anime) }

  describe '#recalculate!' do
    it 'should create Stat' do
      subject.recalculate!
      expect(Stat.first.stats_data).to_not be_nil
    end
  end

  describe '#self.increment' do
    before do
      subject.recalculate!
    end
    it 'should have 10 total' do
      Stat::AnimeGenreBreakdown.increment(user, le.media.genres)
      expect(Stat.last.stats_data['total']).to eq(10)
    end
  end

  describe '#self.decrement' do
    before do
      subject.recalculate!
    end
    it 'should have 0 total' do
      Stat::AnimeGenreBreakdown.decrement(user, le.media.genres)
      expect(Stat.last.stats_data['total']).to eq(0)
    end
  end
end
