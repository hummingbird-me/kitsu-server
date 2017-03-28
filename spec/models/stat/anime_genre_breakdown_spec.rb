require 'rails_helper'

RSpec.describe Stat::AnimeGenreBreakdown do
  let(:user) { create(:user) }
  let(:anime) { create(:anime, :genres) }
  let!(:le) { create(:library_entry, user: user, anime: anime) }

  describe '#recalculate!' do
    it 'should create Stat' do
      subject = Stat.find_by(user: user, type: 'Stat::AnimeGenreBreakdown')
      subject.recalculate!

      expect(Stat.last.stats_data).to_not be_nil
    end
  end

  describe '#self.increment' do
    it 'should have 5 total' do
      record = Stat.find_by(user: user, type: 'Stat::AnimeGenreBreakdown')

      expect(record.stats_data['total']).to eq(5)
    end
  end

  describe '#self.decrement' do
    before do
      Stat::AnimeGenreBreakdown.decrement(user, le.media.genres)
    end
    it 'should have 0 total' do
      record = Stat.find_by(user: user, type: 'Stat::AnimeGenreBreakdown')

      expect(record.stats_data['total']).to eq(0)
    end
  end
end
