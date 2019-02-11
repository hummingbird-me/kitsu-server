require 'rails_helper'

RSpec.describe Pro::ValidateGift do
  let(:alice) { build(:user) }
  let(:bob) { build(:user) }

  context 'when sending to yourself' do
    it 'should raise ProError::InvalidSelfGift' do
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: alice,
          length: '1month'
        )
      }.to raise_error(ProError::InvalidSelfGift)
    end

    context 'for length=forever' do
      it 'should let them buy it anyways lol' do
        expect {
          Pro::ValidateGift.call(
            from: alice,
            to: alice,
            length: 'forever'
          )
        }.not_to raise_error
      end
    end
  end

  context 'when sending to somebody who blocked you' do
    let(:alice) { create(:user) }
    let(:bob) { create(:user) }
    before { Block.create!(user: bob, blocked: alice) }

    it 'should raise ActiveRecord::RecordNotFound' do
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: bob,
          length: '1month'
        )
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the recipient already has pro' do
    it 'should raise ProError::RecipientIsPro' do
      bob.pro_expires_at = 1.month.from_now
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: bob,
          length: '1month'
        )
      }.to raise_error(ProError::RecipientIsPro)
    end
  end

  context 'with an unknown length string' do
    it 'should raise ProError::InvalidLength' do
      expect {
        Pro::ValidateGift.call(
          from: alice,
          to: bob,
          length: '30years'
        )
      }.to raise_error(ProError::InvalidLength)
    end
  end
end
