require 'rails_helper'

RSpec.describe ProRenewalService do
  describe '#renew_for' do
    context 'within the 24-hour grace period' do
      subject { ProRenewalService.new(user) }

      let(:user) { create(:user, pro_expires_at: 6.hours.ago, pro_started_at: 2.years.ago) }

      it 'maintains the existing streak' do
        expect {
          subject.renew_for(Time.now, 1.month.from_now)
        }.not_to(change { user.reload.pro_started_at })
      end
    end

    context 'outside the 24-hour grace period' do
      subject { ProRenewalService.new(user) }

      let(:user) { create(:user, pro_expires_at: 1.week.ago, pro_started_at: 2.years.ago) }

      it 'resets the existing streak' do
        expect {
          subject.renew_for(Time.now, 1.month.from_now)
        }.to(change { user.reload.pro_started_at })
      end
    end

    it 'updates the expiration' do
      user = create(:user, pro_expires_at: Time.now)
      subject = ProRenewalService.new(user)
      expect {
        subject.renew_for(Time.now, 1.month.from_now)
      }.to(change { user.reload.pro_expires_at })
    end
  end
end
