require 'rails_helper'

RSpec.describe YoutubeService::Subscription do
  before do
    stub_request(:post, YoutubeService::Subscription::SUBSCRIBE_URL)
      .with(body: hash_including(
        'hub.callback', 'hub.topic', 'hub.mode', 'hub.secret'
      ))
      .to_return(status: 200)
    linked_account_class = double('LinkedAccount', find: linked_account)
    stub_const('LinkedAccount', linked_account_class)
  end

  let(:linked_account) do
    instance_double('LinkedAccount::YoutubeChannel',
      external_user_id: 'CHANNEL_ID',
      id: 'ID')
  end
  subject { YoutubeService::Subscription.new(linked_account) }

  describe '#topic_url' do
    it 'should return the topic URL for the channel' do
      expect(subject.topic_url).to eq(
        'https://www.youtube.com/xml/feeds/videos.xml?channel_id=CHANNEL_ID'
      )
    end
  end

  describe '#subscribe' do
    it 'should POST to the subscribe url with hub.mode=subscribe' do
      subject.subscribe
      expect(
        a_request(:post, YoutubeService::Subscription::SUBSCRIBE_URL)
          .with(body: hash_including('hub.mode' => 'subscribe'))
      ).to have_been_made.once
    end
  end

  describe '#unsubscribe' do
    it 'should POST to the subscribe url with hub.mode=unsubscribe' do
      subject.unsubscribe
      expect(
        a_request(:post, YoutubeService::Subscription::SUBSCRIBE_URL)
          .with(body: hash_including('hub.mode' => 'unsubscribe'))
      ).to have_been_made.once
    end
  end

  describe '.hmac' do
    it 'should generate an HMAC digest of the data' do
      allow(described_class).to receive(:secret).and_return('SECRET')
      expect(described_class.hmac('hello world')).to eq(
        'd787f3d1bba419806deea7e529800e0f94924434'
      )
    end
  end

  describe '.hmac_matches?' do
    let(:expected_hmac) { 'd787f3d1bba419806deea7e529800e0f94924434' }

    before do
      allow(described_class).to receive(:secret).and_return('SECRET')
    end

    context 'with a correct HMAC' do
      it 'should return true' do
        data = 'hello world'
        expect(described_class.hmac_matches?(data, expected_hmac)).to eq(true)
      end
    end

    context 'with an incorrect HMAC' do
      it 'should return false' do
        data = 'i am evil'
        expect(described_class.hmac_matches?(data, expected_hmac)).to eq(false)
      end
    end
  end
end
