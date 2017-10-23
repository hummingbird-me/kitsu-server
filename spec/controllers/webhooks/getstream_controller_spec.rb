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

  describe '#notify' do
    context 'receiving feed removed notifications' do
      let(:body) { fixture('getstream_webhook/feed_remove_request.json') }

      it 'should return a status of OK' do
        post :notify, body
        expect(response).to have_http_status(:ok)
      end
    end

    context 'receiving some new notification to push' do
      let(:body) { fixture('getstream_webhook/new_feed_request.json') }

      it 'should return a status of OK' do
        post :notify, body
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
