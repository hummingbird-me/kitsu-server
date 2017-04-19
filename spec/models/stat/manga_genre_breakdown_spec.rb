require 'rails_helper'

RSpec.describe Stat::MangaGenreBreakdown do
  let(:user) { create(:user) }
  let(:manga) { create(:manga, :genres) }
  let!(:le) { create(:library_entry, user: user, manga: manga) }

  describe '#recalculate!' do
    it 'should create Stat' do
      subject = Stat.find_by(user: user, type: 'Stat::MangaGenreBreakdown')
      subject.recalculate!

      expect(Stat.last.stats_data).to_not be_nil
    end
  end

  describe '#self.increment' do
    it 'should have 5 total' do
      record = Stat.find_by(user: user, type: 'Stat::MangaGenreBreakdown')

      expect(record.stats_data['total']).to eq(5)
    end
  end

  describe '#self.decrement' do
    before do
      Stat::MangaGenreBreakdown.decrement(user, le)
    end
    it 'should have 0 total' do
      record = Stat.find_by(user: user, type: 'Stat::MangaGenreBreakdown')

      expect(record.stats_data['total']).to eq(0)
    end
  end
end
