require 'rails_helper'

RSpec.describe YoutubeService::NotificationEntry do
  subject { YoutubeService::NotificationEntry.new(entry) }

  let(:notification) do
    Nokogiri::XML.parse(fixture('youtube_service/notification.xml'))
  end
  let(:entry) { notification.at_xpath('//xmlns:entry') }

  describe '#channel_id' do
    it 'returns the value of yt:channelId' do
      expect(subject.channel_id).to eq('CHANNEL_ID')
    end
  end

  describe '#video_id' do
    it 'returns the value of yt:videoId' do
      expect(subject.video_id).to eq('VIDEO_ID')
    end
  end

  describe '#link' do
    it 'returns the href of the link' do
      expect(subject.link).to eq('http://www.youtube.com/watch?v=VIDEO_ID')
    end
  end

  describe '#post_content' do
    it 'includes a link to the video' do
      expect(subject.post_content).to include(subject.link)
    end

    it 'begins with a youtube_video_id comment' do
      expect(subject.post_content).to start_with('<!--youtube_video_id=')
    end
  end

  describe '#content_like' do
    it 'begins with a youtube_video_id comment' do
      expect(subject.content_like).to start_with('<!--youtube_video_id=')
    end

    it 'ends in a percent sign' do
      expect(subject.content_like).to end_with('%')
    end

    it 'matches the start of #post_content' do
      prefix = subject.content_like[0..-2]
      expect(subject.post_content).to start_with(prefix)
    end
  end
end
