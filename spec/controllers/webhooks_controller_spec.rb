require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  let(:linked_account) do
    create(:linked_account,
      type: 'LinkedAccount::YoutubeChannel',
      share_from: true,
      token: 'TEST',
      external_user_id: 'CHANNEL_ID').becomes(LinkedAccount::YoutubeChannel)
  end
  let(:challenge) { 'CHALLENGE' }

  describe '#youtube_verify' do
    context 'for an unsubscribe' do
      it 'should reply with the challenge' do
        get :youtube_verify,
          'linked_account' => '0',
          'hub.mode' => 'unsubscribe',
          'hub.topic' => linked_account.topic_url,
          'hub.challenge' => challenge
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(challenge)
      end
    end

    describe 'for a subscribe' do
      context 'with the correct topic' do
        it 'should reply with the challenge' do
          get :youtube_verify,
            'linked_account' => linked_account.id,
            'hub.mode' => 'subscribe',
            'hub.topic' => linked_account.topic_url,
            'hub.challenge' => challenge
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(challenge)
        end
      end

      context 'with an incorrect topic' do
        it 'should reply with a 404' do
          get :youtube_verify,
            'linked_account' => linked_account.id,
            'hub.mode' => 'subscribe',
            'hub.topic' => 'FAKE TOPIC',
            'hub.challenge' => challenge
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe '#youtube_notify' do
    context 'with a valid HMAC in X-Hub-Signature' do
      let(:secret) { 'SECRET' }
      let(:body) { fixture('youtube_service/notification.xml') }
      let(:hmac) { OpenSSL::HMAC.hexdigest('SHA1', secret, body).to_s }

      before do
        stub_request(:get, 'http://www.youtube.com/watch?v=VIDEO_ID').to_return(status: 200)
        allow(YoutubeService::Subscription).to receive(:secret)
          .and_return(secret)
        @request.headers['Content-Type'] = 'application/atom+xml'
        @request.headers['X-Hub-Signature'] = "sha1=#{hmac}"
        @request.headers['RAW_POST_DATA'] = body
      end

      it 'should return a status of OK' do
        post :youtube_notify, linked_account: linked_account.id
        expect(response).to have_http_status(:ok)
      end

      it 'should create a notification and post it' do
        notif_class = double('YoutubeService::Notification')
        notif = instance_double('YoutubeService::Notification')
        expect(notif_class).to receive(:new).and_return(notif)
        expect(notif).to receive(:post!).with(linked_account.user)
        stub_const('YoutubeService::Notification', notif_class)
        post :youtube_notify, linked_account: linked_account.id
      end
    end

    context 'with an invalid HMAC in X-Hub-Signature' do
      let(:secret) { 'SECRET' }
      let(:body) { fixture('youtube_service/notification.xml') }
      let(:hmac) { OpenSSL::HMAC.hexdigest('SHA1', secret, 'EVIL').to_s }

      before do
        allow(YoutubeService::Subscription).to receive(:secret)
          .and_return(secret)
        @request.headers['Content-Type'] = 'application/atom+xml'
        @request.headers['X-Hub-Signature'] = "sha1=#{hmac}"
        @request.headers['RAW_POST_DATA'] = body
      end

      it 'should return a status of OK' do
        post :youtube_notify, linked_account: linked_account.id
        expect(response).to have_http_status(:ok)
      end

      it 'should not create a notification and post it' do
        notif_class = double('YoutubeService::Notification')
        expect(notif_class).not_to receive(:new)
        stub_const('YoutubeService::Notification', notif_class)
        post :youtube_notify, linked_account: linked_account.id
      end
    end
  end

  describe '#getstream_firehose' do
    context 'receiving feed removed notifications' do
      let(:body) { fixture('getstream_webhook/feed_remove_request.json') }

      it 'should not dispatch notification worker' do
        worker = double(OneSignalNotificationWorker)
        expect(worker).not_to receive(:perform_async)
        stub_const('OneSignalNotificationWorker', worker)
        post :getstream_firehose, body
      end

      it 'should return a status of OK' do
        post :getstream_firehose, body
        expect(response).to have_http_status(:ok)
      end
    end

    context 'receiving some new notification to push' do
      let(:body) { fixture('getstream_webhook/new_feed_request.json') }

      it 'should dispatch multiple notification workers' do
        worker = double(OneSignalNotificationWorker)
        expect(worker).to receive(:perform_async).exactly(7).times
        stub_const('OneSignalNotificationWorker', worker)
        post :getstream_firehose, body
      end

      it 'should return a status of OK' do
        post :getstream_firehose, body
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
