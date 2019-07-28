require 'rails_helper'

RSpec.describe Accounts::SendConfirmationEmail do
  let!(:user) { create(:user) }

  it 'should send an email to the user' do
    expect {
      described_class.call(user: user)
    }.to(change { ActionMailer::Base.deliveries.size }.by(1))

    email = ActionMailer::Base.deliveries.last

    expect(email.to[0]).to include(user.email)
  end

  context 'when a hard bounce occurs' do
    it 'should catch the error and set the user to bounced' do
      expect(UserMailer).to receive(:confirmation).and_raise(MailSendError::HardBounce)

      expect {
        described_class.call(user: user)
      }.to(change { user.reload.email_status }.to('email_bounced'))
    end
  end

  context 'when a soft bounce occurs' do
    it 'should allow the error to bubble' do
      expect(UserMailer).to receive(:confirmation).and_raise(MailSendError::SoftBounce)

      expect {
        described_class.call(user: user)
      }.to raise_error(MailSendError::SoftBounce)
    end
  end
end
