require 'rails_helper'

RSpec.describe Webhooks::GetstreamController, type: :controller do
  let(:username) { ENV['STREAM_WEBHOOK_USER'] }
  let(:password) { ENV['STREAM_WEBHOOK_PASS'] }
  let(:auth) { "Basic #{Base64.encode64("#{username}:#{password}")}" }

  before do
    @request.headers['Authorization'] = auth
  end

  describe '#verify' do
    before { get :verify }

    it 'should return the API key' do
      expect(response.body).to eq(StreamRails.client.api_key)
    end

    it 'should return a 200 OK status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'without webhook credentials configured' do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('STREAM_WEBHOOK_USER', nil).and_return(nil)
      get :verify
    end

    it 'returns a 401 Unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with the wrong credentials' do
    let(:password) { 'wrong' }

    it 'returns a 401 Unauthorized status' do
      get :verify
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#notify' do
    context 'receiving feed removed notifications' do
      let(:body) { fixture('getstream_webhook/feed_remove_request.json') }

      it 'should return a status of OK' do
        post :notify, body: body
        expect(response).to have_http_status(:ok)
      end
    end

    context 'receiving some new notification to push' do
      let(:body) { fixture('getstream_webhook/new_feed_request.json') }

      it 'should return a status of OK' do
        post :notify, body: body
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
