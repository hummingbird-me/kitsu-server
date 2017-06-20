require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe OneSignalNotificationWorker do
  around(:each) do
    Sidekiq::Worker.clear_all
    Sidekiq::Testing.inline! { yield }
  end

  describe '#perform' do
    let(:request) do
      JSON.parse(fixture('getstream_webhook/post_reply_request.json')).first
    end
    let!(:actor) { FactoryGirl.create(:user, id: 4) }

    before do
      allow_any_instance_of(OneSignalNotificationService)
        .to receive(:notify_players!) {}
      allow(OneSignalNotificationService).to receive(:new) {}
    end

    context 'when user has subscribed to one signal' do
      let!(:target) do
        FactoryGirl.create(:user, :subscribed_to_one_signal, id: 1)
      end

      it 'should initialize one signal notification service' do
        service_class = double('OneSignalNotificationService')
        service = instance_double('OneSignalNotificationService')
        expect(service_class).to receive(:new).and_return(service)
        expect(service).to receive(:notify_players!)
        stub_const('OneSignalNotificationService', service_class)
        OneSignalNotificationWorker.perform_async(request)
      end
    end

    context 'when user not found in our system' do
      it 'should not initialize one signal notification service' do
        service_class = double('OneSignalNotificationService')
        expect(service_class).not_to receive(:new)
        OneSignalNotificationWorker.perform_async(request)
      end
    end

    context 'when user does not subscribe to one signal' do
      let!(:target) { FactoryGirl.create(:user, id: 1) }

      it 'should not initialize one signal notification service' do
        service_class = double('OneSignalNotificationService')
        expect(service_class).not_to receive(:new)
        OneSignalNotificationWorker.perform_async(request)
      end
    end
  end
end
