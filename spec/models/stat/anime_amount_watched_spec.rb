require 'rails_helper'

RSpec.describe Stat::AnimeAmountWatched do
  # will create some library entries for me
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }
  let(:anime1) { create(:anime) }
  let!(:le) { create(:library_entry, user: user, anime: anime, progress: 10) }
  let!(:le1) { create(:library_entry, user: user, anime: anime1, progress: 5) }

  before(:each) do
    subject = Stat.find_by(user: user, type: 'Stat::AnimeAmountWatched')
    subject.recalculate!
  end

  describe '#recalculate!' do
    it 'should add all library entries related to user' do
      record = Stat.find_by(user: user, type: 'Stat::AnimeAmountWatched')

      expect(record.stats_data['all_time']['total_anime']).to eq(2)
      expect(record.stats_data['all_time']['total_episodes']).to eq(15)
      expect(record.stats_data['all_time']['total_time']).to eq(360)
    end
  end

  describe '#self.increment' do
    it 'should update all stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::AnimeAmountWatched')

      expect(record.stats_data['all_time']['total_anime']).to eq(2)
      expect(record.stats_data['all_time']['total_episodes']).to eq(15)
      expect(record.stats_data['all_time']['total_time']).to eq(360)
    end
  end

  describe '#self.decrement' do
    before do
      Stat::AnimeAmountWatched.decrement(user, le)
    end
    it 'should remove le from stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::AnimeAmountWatched')

      expect(record.stats_data['all_time']['total_anime']).to eq(1)
      expect(record.stats_data['all_time']['total_episodes']).to eq(5)
      expect(record.stats_data['all_time']['total_time']).to eq(120)
    end
  end
end
