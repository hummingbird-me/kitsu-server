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

RSpec.describe Stat, type: :model do
  subject { build(:stat) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:type) }
  it { should validate_uniqueness_of(:type).scoped_to(:user_id) }

  class TestStat < Stat
    attr_reader :recalculated
    def recalculate!
      @recalculated = true
    end
  end

  describe '.for_user' do
    let(:user) { create(:user) }

    context 'with no existing row' do
      it 'should create an instance and call recalculate!' do
        stat = TestStat.for_user(user)
        expect(stat.user).to eq(user)
        expect(stat.recalculated).to be_truthy
      end
    end

    context 'with an existing row' do
      let!(:row) { TestStat.create!(user: user) }

      it 'should return the existing instance without calling recalculate!' do
        stat = TestStat.for_user(user)
        expect(stat).to eq(row)
        expect(stat.recalculated).to be_falsy
      end
    end
  end

  describe '#reset_data' do
    it 'resets the stats_data attribute to the return value of default_data' do
      stat = TestStat.new
      expect(stat).to receive(:default_data).and_return('foo' => 'bar')
      stat.reset_data
      expect(stat.stats_data).to eq('foo' => 'bar')
    end
  end
end
