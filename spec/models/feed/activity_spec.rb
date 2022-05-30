require 'rails_helper'

RSpec.describe Feed::Activity, type: :model do
  subject(:activity) { described_class.new(feed) }

  let(:feed) { Feed.new('user', '1') }

  describe '#as_json' do
    it 'converts time to ISO8601' do
      time = Time.now
      activity = described_class.new(feed, time: time)
      json = activity.as_json
      expect(json[:time]).to eq(time.iso8601)
    end

    it 'converts values with stream_id to their stream_id' do
      obj = OpenStruct.new(stream_id: 'test')
      activity = described_class.new(feed, object: obj)
      json = activity.as_json
      expect(json[:object]).to eq('test')
    end

    it 'includes arbitrary properties' do
      activity = described_class.new(feed, thing: 'doodle')
      json = activity.as_json
      expect(json[:thing]).to eq('doodle')
    end
  end

  describe '#create' do
    let(:activity_list) { instance_spy(Feed::ActivityList) }
    let(:feed) { instance_spy(Feed) }

    before do
      allow(activity).to receive(:feed).and_return(feed)
      allow(feed).to receive(:activities).and_return(activity_list)
    end

    it 'adds activity to feed' do
      activity.create
      expect(activity_list).to have_received(:add).with(activity)
    end

    it 'updates activity in feed' do
      activity.update
      expect(activity_list).to have_received(:update).with(activity)
    end

    it 'destroys activity in the feed' do
      activity.destroy
      expect(activity_list).to have_received(:destroy).with(activity)
    end
  end

  it 'allows setting arbitrary properties via methods' do
    activity.doodle = 'test'
    expect(activity.doodle).to eq('test')
  end

  it 'returns nil for properties which are not set' do
    expect(activity.doodle).to be_nil
  end

  it 'coerces an ISO8601 timestring into an actual Time' do
    time = Time.now.round
    activity = described_class.new(feed, time: time.iso8601)
    expect(activity.time).to eq(time)
  end
end
