require 'rails_helper'

RSpec.describe Billing::ProcessBraintreeWebhook do
  describe 'for subscription_cancelled event' do
    let(:user) { create(:user) }
    let(:subscription) do
      Pro::SubscribeWithBraintree.call(
        user: user,
        tier: 'pro',
        nonce: 'fake-paypal-billing-agreement-nonce'
      ).subscription
    end
    let!(:notification) do
      $braintree.webhook_testing.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionCanceled,
        subscription.billing_id
      )
    end

    it 'should cancel the subscription' do
      expect {
        Billing::ProcessBraintreeWebhook.call(
          signature: notification[:bt_signature],
          payload: notification[:bt_payload]
        )
      }.to change { ProSubscription.count }.by(-1)
    end

    it 'should email the user to inform them of the cancellation' do
      expect(ProMailer).to receive_message_chain(:cancellation_email, :deliver_later)

      Billing::ProcessBraintreeWebhook.call(
        signature: notification[:bt_signature],
        payload: notification[:bt_payload]
      )
    end
  end

  describe 'for subscription_charged_successfully event' do
    let(:user) { create(:user) }
    let(:subscription) do
      Pro::SubscribeWithBraintree.call(
        user: user,
        tier: 'pro',
        nonce: 'fake-paypal-billing-agreement-nonce'
      ).subscription
    end
    let!(:notification) do
      $braintree.webhook_testing.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionChargedSuccessfully,
        subscription.billing_id
      )
    end

    it 'should extend the end of the user pro period' do
      action = Billing::ProcessBraintreeWebhook.new(
        signature: notification[:bt_signature],
        payload: notification[:bt_payload]
      )
      allow(action.event.subscription).to receive(:billing_period_start_date) { 24.hours.ago }
      allow(action.event.subscription).to receive(:billing_period_end_date) { 1.month.from_now }

      expect {
        action.call
      }.to(change { user.reload.pro_expires_at })
    end
  end

  describe 'for subscription_charged_unsuccessfully event' do
    let(:user) { create(:user) }
    let(:subscription) do
      Pro::SubscribeWithBraintree.call(
        user: user,
        tier: 'pro',
        nonce: 'fake-paypal-billing-agreement-nonce'
      ).subscription
    end
    let!(:notification) do
      $braintree.webhook_testing.sample_notification(
        Braintree::WebhookNotification::Kind::SubscriptionChargedUnsuccessfully,
        subscription.billing_id
      )
    end

    it 'should send an email to the user' do
      expect(ProMailer).to receive_message_chain(:billing_issue_email, :deliver_later)

      Billing::ProcessBraintreeWebhook.call(
        signature: notification[:bt_signature],
        payload: notification[:bt_payload]
      )
    end
  end
end
