require 'rails_helper'

RSpec.describe Stat::MangaFavoriteYear do
  let(:user) { create(:user) }
  let(:manga) { create(:manga, start_date: 'Tue, 19 Apr 2016') }
  let(:manga1) { create(:manga, start_date: 'Tue, 19 Apr 2014') }
  let!(:le) { create(:library_entry, user: user, manga: manga) }
  let!(:le1) { create(:library_entry, user: user, manga: manga1) }

  before(:each) do
    subject = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')
    subject.recalculate!
  end

  describe '#recalculate!' do
    it 'should add all library entries related to user' do
      record = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')

      expect(record.stats_data['2016']).to eq(1)
      expect(record.stats_data['2014']).to eq(1)
      expect(record.stats_data['total']).to eq(2)
    end
  end

  describe '#increment' do
    before do
      manga2 = create(:manga, start_date: 'Tue, 19 Apr 2012')
      create(:library_entry, user: user, manga: manga2)
    end

    it 'should add LibraryEntry manga start_date into stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')

      expect(record.stats_data['2012']).to eq(1)
      expect(record.stats_data['total']).to eq(3)
    end
  end

  describe '#decrement' do
    before do
      Stat::MangaFavoriteYear.decrement(user, le)
    end
    it 'should remove LibraryEntry manga start_date from stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaFavoriteYear')

      expect(record.stats_data['2016']).to eq(0)
      expect(record.stats_data['total']).to eq(1)
    end
  end
end
