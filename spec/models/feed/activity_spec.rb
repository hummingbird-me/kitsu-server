require 'rails_helper'

RSpec.describe Feed::Activity, type: :model do
  let(:feed) { Feed.new('user', '1') }
  subject { Feed::Activity.new(feed) }

  describe '#as_json' do
    it 'should convert time to ISO8601' do
      time = Time.now
      activity = Feed::Activity.new(feed, time: time)
      json = activity.as_json
      expect(json[:time]).to eq(time.iso8601)
    end
    it 'should convert values with stream_id to their stream_id' do
      obj = OpenStruct.new(stream_id: 'test')
      activity = Feed::Activity.new(feed, object: obj)
      json = activity.as_json
      expect(json[:object]).to eq('test')
    end
    it 'should include arbitrary properties' do
      activity = Feed::Activity.new(feed, thing: 'doodle')
      json = activity.as_json
      expect(json[:thing]).to eq('doodle')
    end
  end

  describe '#create' do
    let(:activity_list) { double }
    let(:feed) { double }
    before do
      allow(subject).to receive(:feed).and_return(feed)
      allow(feed).to receive(:activities).and_return(activity_list)
    end
    it 'should add activity to feed' do
      expect(activity_list).to receive(:add).with(subject)
      subject.create
    end
    it 'should update activity in feed' do
      expect(activity_list).to receive(:update).with(subject)
      subject.update
    end
    it 'should destroy activity in the feed' do
      expect(activity_list).to receive(:destroy).with(subject)
      subject.destroy
    end
  end

  it 'should allow setting arbitrary properties via methods' do
    subject.doodle = 'test'
    expect(subject.doodle).to eq('test')
  end

  it 'should return nil for properties which are not set' do
    expect(subject.doodle).to be_nil
  end

  it 'should coerce an ISO8601 timestring into an actual Time' do
    time = Time.now.round
    activity = Feed::Activity.new(feed, time: time.iso8601)
    expect(activity.time).to eq(time)
  end
end
