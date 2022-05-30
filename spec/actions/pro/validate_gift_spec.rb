require 'rails_helper'

RSpec.describe Pro::ValidateGift do
  let(:alice) { build(:user) }
  let(:bob) { build(:user) }

  context 'when sending to yourself' do
    it 'raises ProError::InvalidSelfGift' do
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: alice,
          tier: 'pro'
        )
      }.to raise_error(ProError::InvalidSelfGift)
    end
  end

  context 'when sending to somebody who blocked you' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }

    before { Block.create!(user: bob, blocked: alice) }

    it 'raises ActiveRecord::RecordNotFound' do
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: bob,
          tier: 'pro'
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the recipient already has pro' do
    it 'raises ProError::RecipientIsPro' do
      bob.pro_expires_at = 1.month.from_now
      bob.pro_tier = :pro
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: bob,
          tier: 'pro'
        )
      }.to raise_error(ProError::RecipientIsPro)
    end
  end

  context 'with an unknown tier' do
    it 'raises ProError::InvalidTier' do
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: bob,
          tier: 'godly'
        )
      }.to raise_error(ProError::InvalidTier)
    end
  end
end
