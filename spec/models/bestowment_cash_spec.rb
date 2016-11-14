# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: bestowment_cashes
#
#  id         :integer          not null, primary key
#  number     :integer          default(0), not null
#  rank       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  badge_id   :string           not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe BestowmentCash, type: :model do
  it { should validate_presence_of(:badge_id) }
  it do
    should validate_uniqueness_of(:badge_id)
      .scoped_to(:rank)
      .with_message('should be one per rank')
  end

  describe '#inc' do
    before { 10.times { create :bestowment } }

    it 'cash LikingFeedPostsBadge count 10' do
      expect(
        BestowmentCash.where(badge_id: 'LikingFeedPostsBadge').first.number
      ).to eq(10)
    end
  end
end
