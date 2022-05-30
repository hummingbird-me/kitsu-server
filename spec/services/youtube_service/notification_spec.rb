require 'rails_helper'

RSpec.describe YoutubeService::Notification do
  subject { YoutubeService::Notification.new(xml) }

  let(:user) { build(:user) }
  let(:xml) { fixture('youtube_service/notification.xml') }

  describe '#post!' do
    it 'runs #post! on each entry' do
      entry = instance_double(YoutubeService::NotificationEntry)
      expect(entry).to receive(:post!).with(user).once
      allow(subject).to receive(:entries).and_return([entry])
      subject.post!(user)
    end
  end

  describe '#entries' do
    it 'creates a NotificationEntry for each <entry>' do
      entries = described_class.new(<<-XML).entries
        <feed xmlns:yt="http://www.youtube.com/xml/schemas/2015"
              xmlns="http://www.w3.org/2005/Atom">
          <entry></entry>
          <entry></entry>
          <entry></entry>
          <entry></entry>
          <entry></entry>
        </feed>
      XML
      expect(entries).to all(be_a(YoutubeService::NotificationEntry))
    end
  end
end
