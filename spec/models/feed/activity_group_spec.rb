require 'rails_helper'

RSpec.describe Feed::ActivityGroup, type: :model do
  let(:feed) { Feed.new('user', '1') }

  it 'should coerce activities into Activity instances' do
    ag = Feed::ActivityGroup.new(feed, {activities: [{test: 'foo'}]})
    expect(ag.activities.first).to be_a(Feed::Activity)
    expect(ag.activities.first[:test]).to eq('foo')
  end

  describe '#empty?' do
    context 'when activities is nil' do
      it 'should return true' do
        ag = Feed::ActivityGroup.new(feed)
        expect(ag.empty?).to eq(true)
      end
    end
    context 'when activities is empty' do
      it 'should return true' do
        ag = Feed::ActivityGroup.new(feed, activities: [])
        expect(ag.empty?).to eq(true)
      end
    end
    context 'when activities is not empty' do
      it 'should return false' do
        ag = Feed::ActivityGroup.new(feed, activities: [{ foo: 'bar' }])
        expect(ag.empty?).to eq(false)
      end
    end
  end
end
