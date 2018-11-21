require 'rails_helper'

RSpec.describe ProGiftService do
  describe '#send' do
    context 'with a valid gift' do
      it 'should send an email to the recipient of the gift' do
        from = build(:user)
        to = build(:user)

        delivery = instance_double(ActionMailer::MessageDelivery)
        expect(ProMailer).to receive(:gift_email).and_return(delivery).once
        expect(delivery).to receive(:deliver_later).once

        ProGiftService.new(from: from, to: to, length: :year).send
      end

      context 'of a year of pro' do
        it 'should update the pro expiry of the user to a year in the future' do
          from = build(:user)
          to = create(:user)
          Timecop.freeze do
            expect {
              ProGiftService.new(from: from, to: to, length: :year).send
            }.to(change { to.reload.pro_expires_at })
            expect(to.reload.pro_expires_at).to eq(1.year.from_now)
          end
        end
      end

      context 'of a month of pro' do
        it 'should update the pro expiry of the recipient to a month in the future' do
          from = build(:user)
          to = create(:user)
          Timecop.freeze do
            expect {
              ProGiftService.new(from: from, to: to, length: :month).send
            }.to(change { to.reload.pro_expires_at }.to(1.month.from_now))
          end
        end
      end
    end
  end

  describe '#validate!' do
    context 'with the same sender and recipient' do
      it 'should raise an InvalidSelfGift error' do
        user = build(:user)
        expect {
          ProGiftService.new(from: user, to: user, length: :year).validate!
        }.to raise_error(ProGiftService::InvalidSelfGift)
      end
    end

    context 'with a recipient who already has pro' do
      it 'should raise an RecipientIsPro error' do
        from = build(:user)
        to = build(:user, pro_expires_at: 2.months.from_now)
        expect {
          ProGiftService.new(from: from, to: to, length: :year).validate!
        }.to raise_error(ProGiftService::RecipientIsPro)
      end
    end

    context 'with an invalid length' do
      it 'should raise an InvalidLength error' do
        from = build(:user)
        to = build(:user)
        expect {
          ProGiftService.new(from: from, to: to, length: :decade).validate!
        }.to raise_error(ProGiftService::InvalidLength)
      end
    end
  end
end
