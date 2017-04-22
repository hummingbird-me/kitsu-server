require 'rails_helper'

RSpec.describe Stat::MangaActivityHistory do
  let(:user) { create(:user) }
  let(:manga) { create(:manga) }
  let(:manga1) { create(:manga) }
  let!(:le) { create(:library_entry, user: user, manga: manga) }
  let!(:le1) { create(:library_entry, user: user, manga: manga1) }
  let!(:event) { create(:library_event, user: user, library_entry: le) }

  before(:each) do
    subject = Stat.find_by(user: user, type: 'Stat::MangaActivityHistory')
    subject.recalculate!
  end

  describe '#recalculate!' do
    it 'should add all library entries related to user' do
      record = Stat.find_by(user: user, type: 'Stat::MangaActivityHistory')

      expect(record.stats_data['total']).to eq(3)
      expect(record.stats_data['activity'].count).to eq(3)
    end
  end

  describe '#increment' do
    before do
      manga2 = create(:manga)
      create(:library_entry, user: user, manga: manga2)
    end
    it 'should update all stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaActivityHistory')
      expect(record.stats_data['total']).to eq(4)
      expect(record.stats_data['activity'].count).to eq(4)
    end
  end

  describe '#decrement' do
    before do
      Stat::MangaActivityHistory.decrement(user, le)
    end
    it 'should remove all library events from stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaActivityHistory')
      expect(record.stats_data['total']).to eq(1)
      expect(record.stats_data['activity'].count).to eq(1)
    end
  end
end
