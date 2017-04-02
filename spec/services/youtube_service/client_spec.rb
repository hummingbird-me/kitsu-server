require 'rails_helper'

RSpec.describe YoutubeService::Client do
  let(:api_key) { 'API_KEY' }
  let(:token) { 'TOKEN' }

  subject { described_class.new(token, api_key: api_key) }

  describe '#valid?' do
    context 'when aud matches key' do
      before do
        stub_request(:get, YoutubeService::Client::VERIFY_URL)
          .with(query: hash_including(access_token: token))
          .to_return(status: 200, body: { aud: api_key }.to_json)
      end

      it 'should return true' do
        expect(subject.valid?).to eq(true)
      end
    end

    context 'when aud does not match key' do
      before do
        stub_request(:get, YoutubeService::Client::VERIFY_URL)
          .with(query: hash_including(access_token: token))
          .to_return(status: 200, body: { aud: 'EVIL_KEY' }.to_json)
      end

      it 'should return false' do
        expect(subject.valid?).to eq(false)
      end
    end

    context 'when the request fails' do
      before do
        stub_request(:get, YoutubeService::Client::VERIFY_URL)
          .to_return(status: 500)
      end

      it 'should return false' do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe '#channel_id' do
    it 'should return the channel ID of the user' do
      response = {
        kind: 'youtube#channelListResponse',
        pageInfo: {
          totalResults: 1,
          resultsPerPage: 1
        },
        items: [{
          kind: 'youtube#channel',
          id: 'CHANNEL_ID'
        }]
      }
      stub_request(:get, YoutubeService::Client::CHANNEL_URL)
        .with(query: hash_including(access_token: token))
        .to_return(body: response.to_json)
      expect(subject.channel_id).to eq('CHANNEL_ID')
    end
  end
end
