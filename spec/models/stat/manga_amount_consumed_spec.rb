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

RSpec.describe Stat::MangaAmountConsumed do
  # will create some library entries for me
  let(:user) { create(:user) }
  let(:manga) { create(:manga) }
  let(:manga1) { create(:manga) }
  let(:le) { create(:library_entry, user: user, manga: manga, progress: 10, time_spent: 0) }
  let(:le1) { create(:library_entry, user: user, manga: manga1, progress: 5, time_spent: 0) }

  before do
    Stat::MangaAmountConsumed.increment(user, le)
    Stat::MangaAmountConsumed.increment(user, le1)
    user.stats.find_or_initialize_by(type: 'Stat::MangaAmountConsumed').recalculate!
  end

  describe '#recalculate!' do
    it 'should add all library entries related to user' do
      record = Stat.find_by(user: user, type: 'Stat::MangaAmountConsumed')

      expect(record.stats_data['all_time']['total_media']).to eq(2)
      expect(record.stats_data['all_time']['total_progress']).to eq(15)
      expect(record.stats_data['all_time']['total_time']).to eq(0)
    end
  end

  describe '#increment' do
    it 'should update all stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaAmountConsumed')

      expect(record.stats_data['all_time']['total_media']).to eq(2)
      expect(record.stats_data['all_time']['total_progress']).to eq(15)
      expect(record.stats_data['all_time']['total_time']).to eq(0)
    end
  end

  describe '#decrement' do
    before do
      Stat::MangaAmountConsumed.decrement(user, le)
    end
    it 'should remove le from stats_data' do
      record = Stat.find_by(user: user, type: 'Stat::MangaAmountConsumed')

      expect(record.stats_data['all_time']['total_media']).to eq(1)
      expect(record.stats_data['all_time']['total_progress']).to eq(5)
      expect(record.stats_data['all_time']['total_time']).to eq(0)
    end
  end
end
