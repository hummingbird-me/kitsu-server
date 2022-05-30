require 'rails_helper'

RSpec.describe GooglePlayNotificationService do
  context 'with a renewal' do
    subject { described_class.new(notif) }

    let(:notif) do
      {
        'message' => {
          'data' => 'eyJ2ZXJzaW9uIjoiMS4wIiwicGFja2FnZU5hbWUiOiJjb20uZXZlcmZveC5hbmltZXRyYWNrZXJhbmRyb2lkIiwiZXZlbnRUaW1lTWlsbGlzIjoiMTUwMzM0OTU2NjE2OCIsInN1YnNjcmlwdGlvbk5vdGlmaWNhdGlvbiI6eyJ2ZXJzaW9uIjoiMS4wIiwibm90aWZpY2F0aW9uVHlwZSI6MiwicHVyY2hhc2VUb2tlbiI6IlBVUkNIQVNFX1RPS0VOIiwic3Vic2NyaXB0aW9uSWQiOiJteS5za3UifX0='
        }
      }
    end

    describe '#token' do
      it 'returns the value in subscriptionNotification.purchaseToken in the data payload' do
        expect(subject.token).to eq('PURCHASE_TOKEN')
      end
    end

    describe '#event' do
      it 'returns :renewed' do
        expect(subject.event).to eq(:renewed)
      end
    end
  end

  context 'with a cancellation' do
    subject { described_class.new(notif) }

    let(:notif) do
      {
        'message' => {
          'data' => 'eyJ2ZXJzaW9uIjoiMS4wIiwicGFja2FnZU5hbWUiOiJjb20uZXZlcmZveC5hbmltZXRyYWNrZXJhbmRyb2lkIiwiZXZlbnRUaW1lTWlsbGlzIjoiMTUwMzM0OTU2NjE2OCIsInN1YnNjcmlwdGlvbk5vdGlmaWNhdGlvbiI6eyJ2ZXJzaW9uIjoiMS4wIiwibm90aWZpY2F0aW9uVHlwZSI6MywicHVyY2hhc2VUb2tlbiI6IlBVUkNIQVNFX1RPS0VOIiwic3Vic2NyaXB0aW9uSWQiOiJteS5za3UifX0='
        }
      }
    end

    describe '#call' do
      it 'destroys the subscription' do
        subscription = instance_double(ProSubscription::GooglePlaySubscription)
        allow(subject).to receive(:subscription).and_return(subscription)
        expect(subscription).to receive(:destroy!).once
        subject.call
      end
    end
  end
end
