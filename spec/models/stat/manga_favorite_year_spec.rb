require 'rails_helper'

RSpec.describe Stat::MangaFavoriteYear do
  let(:user) { create(:user) }
  let(:manga) { create(:manga, start_date: 'Tue, 19 Apr 2016') }
  let(:manga1) { create(:manga, start_date: 'Tue, 19 Apr 2014') }
  let!(:le) { create(:library_entry, user: user, manga: manga, progress: 1) }
  let!(:le1) { create(:library_entry, user: user, manga: manga1, progress: 1) }

  before do
    Stat::MangaFavoriteYear.increment(user, le)
    Stat::MangaFavoriteYear.increment(user, le1)
    user.stats.find_or_initialize_by(type: 'Stat::MangaFavoriteYear').recalculate!
  end

  describe '#recalculate!' do
    it 'adds all library entries related to user' do
      record = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')

      expect(record.stats_data['all_years']['2016']).to eq(1)
      expect(record.stats_data['all_years']['2014']).to eq(1)
      expect(record.stats_data['total']).to eq(2)
      expect(record.stats_data['total_media']).to eq(2)
    end
  end

  describe '#increment' do
    before do
      manga2 = create(:manga, start_date: 'Tue, 19 Apr 2012')
      le2 = create(:library_entry, user: user, manga: manga2)
      Stat::MangaFavoriteYear.increment(user, le2)
    end

    it 'adds LibraryEntry manga start_date into stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')

      expect(record.stats_data['all_years']['2012']).to eq(1)
      expect(record.stats_data['total']).to eq(3)
      expect(record.stats_data['total_media']).to eq(3)
    end
  end

  describe '#decrement' do
    before do
      Stat::MangaFavoriteYear.decrement(user, le)
    end

    it 'removes LibraryEntry manga start_date from stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')

      expect(record.stats_data['all_years']['2016']).to eq(0)
      expect(record.stats_data['total']).to eq(1)
      expect(record.stats_data['total_media']).to eq(1)
    end
  end
end
