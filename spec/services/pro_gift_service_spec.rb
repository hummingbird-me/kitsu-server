require 'rails_helper'

RSpec.describe ProGiftService do
  context 'with a valid gift' do
    it 'should send an email to the recipient of the gift' do
      from = build(:user)
      to = build(:user)

      delivery = instance_double(ActionMailer::MessageDelivery)
      expect(ProMailer).to receive(:gift_email).and_return(delivery).once
      expect(delivery).to receive(:deliver_later).once

      ProGiftService.new(from: from, to: to).call
    end

    it 'should update the pro expiry of the user' do
      from = build(:user)
      to = create(:user)
      expect {
        ProGiftService.new(from: from, to: to).call
      }.to(change { to.reload.pro_expires_at })
    end
  end

  context 'with the same sender and recipient' do
    it 'should raise an InvalidSelfGift error' do
      user = build(:user)
      expect {
        ProGiftService.new(from: user, to: user).call
      }.to raise_error(ProGiftService::InvalidSelfGift)
    end
  end

  context 'with a recipient who already has pro' do
    it 'should raise an RecipientIsPro error' do
      from = build(:user)
      to = build(:user, pro_expires_at: 2.months.from_now)
      expect {
        ProGiftService.new(from: from, to: to).call
      }.to raise_error(ProGiftService::RecipientIsPro)
    end
  end
end
