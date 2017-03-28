require 'rails_helper'

RSpec.describe Stat::AnimeAmountWatched do
  subject do
    create(:stat, user: user, type: 'Stat::AnimeAmountWatched')
      .becomes(Stat::AnimeAmountWatched)
  end

  # will create some library entries for me
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }
  let(:anime1) { create(:anime) }
  let!(:le) { create(:library_entry, user: user, anime: anime, progress: 10) }
  let(:le1) { create(:library_entry, user: user, anime: anime1, progress: 5) }

  describe '#recalculate!' do
    before do
      le1
    end
    it 'should create Stat' do
      subject.recalculate!
      expect(Stat.last.stats_data).to_not be_nil
    end

    it 'should add add all library entries related to user' do
      subject.recalculate!
      record = Stat.last

      expect(record.stats_data['all_time']['total_anime']).to eq(2)
      expect(record.stats_data['all_time']['total_episodes']).to eq(15)
      expect(record.stats_data['all_time']['total_time']).to eq(360)
    end
  end

  describe '#self.increment' do
    before do
      subject.recalculate!
    end
    it 'should update all stats_data' do
      Stat::AnimeAmountWatched.increment(user, le1)
      record = Stat.last

      expect(record.stats_data['all_time']['total_anime']).to eq(2)
      expect(record.stats_data['all_time']['total_episodes']).to eq(15)
      expect(record.stats_data['all_time']['total_time']).to eq(360)
    end
  end

  describe '#self.decrement' do
    before do
      le1
      subject.recalculate!
    end
    it 'should remove le from stats_data' do
      Stat::AnimeAmountWatched.decrement(user, le)
      record = Stat.last

      expect(record.stats_data['all_time']['total_anime']).to eq(1)
      expect(record.stats_data['all_time']['total_episodes']).to eq(5)
      expect(record.stats_data['all_time']['total_time']).to eq(120)
    end
  end
end
