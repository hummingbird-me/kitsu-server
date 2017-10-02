# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  stats_data :jsonb            not null
#  type       :string           not null, indexed => [user_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null, indexed => [type], indexed
#
# Indexes
#
#  index_stats_on_type_and_user_id  (type,user_id) UNIQUE
#  index_stats_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_9e94901167  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Stat::AnimeActivityHistory do
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }
  let!(:le) { create(:library_entry, user: user, anime: anime) }

  def update_same_library_entries(amount)
    library_entry = LibraryEntry.first

    amount.times do |index|
      library_entry.update(progress: index + 1)
    end
  end

  def create_library_entries(amount)
    amount.times do
      anime1 = create(:anime)
      create(:library_entry, user: user, anime: anime1, progress: 1)
    end
  end

  def day(record, date)
    record.stats_data['days'][date.year.to_s][date.month.to_s][date.day.to_s]
  end

  describe '#recalculate!' do
    it 'should add all library entries related to user' do
      create_library_entries(2)
      library_event = LibraryEvent.last
      record = Stat.find_by(user: user, type: 'Stat::AnimeActivityHistory')
      date = library_event.created_at.to_date
      record.recalculate!

      expect(day(record, date)['total_time']).to eq(48)
      expect(day(record, date)['total_progress']).to eq(2)
      expect(record.stats_data['total_progress']).to eq(2)
      expect(record.stats_data['week_high_score']).to eq(2)
      expect(record.stats_data['last_update_date']).to eq(date)
    end
  end

  describe '#increment' do
    context 'positive progress change' do
      it 'should work with 1 increment' do
        update_same_library_entries(1)
        library_event = LibraryEvent.last
        record = Stat.find_by(user: user, type: 'Stat::AnimeActivityHistory')
        date = library_event.created_at.to_date

        expect(day(record, date)['total_time']).to eq(24)
        expect(day(record, date)['total_progress']).to eq(1)
        expect(record.stats_data['total_progress']).to eq(1)
        expect(record.stats_data['week_high_score']).to eq(1)
        expect(record.stats_data['last_update_date']).to eq(date.to_s)
      end

      context 'adding new anime with different dates' do
        it 'should work with 3 increments with progress changes' do
          skip('Can only test once background workers are implemented for stats')
        end

        it 'should work with 9 increments with progress changes' do
          skip('Can only test once background workers are implemented for stats')
        end
      end

      context 'updating same anime' do
        it 'should work with 3 increments with progress changes' do
          update_same_library_entries(3)
          library_event = LibraryEvent.last
          record = Stat.find_by(user: user, type: 'Stat::AnimeActivityHistory')
          date = library_event.created_at.to_date

          expect(day(record, date)['total_time']).to eq(72)
          expect(day(record, date)['total_progress']).to eq(3)
          expect(record.stats_data['total_progress']).to eq(3)
          expect(record.stats_data['week_high_score']).to eq(3)
          expect(record.stats_data['last_update_date']).to eq(date.to_s)
        end
      end
    end

    context 'negative progress change' do
      it 'should not return any negative numbers with 1 negative increment' do
        skip('Can only test once background workers are implemented for stats')
      end

      it 'should work with 3 increments with 1 negative increment' do
        skip('Can only test once background workers are implemented for stats')
      end
    end
  end
end
