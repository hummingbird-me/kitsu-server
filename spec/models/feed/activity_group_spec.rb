require 'rails_helper'

RSpec.describe Feed::ActivityGroup, type: :model do
  let(:feed) { Feed.new('user', '1') }

  it 'should coerce activities into Activity instances' do
    ag = Feed::ActivityGroup.new(feed, {activities: [{test: 'foo'}]})
    expect(ag.activities.first).to be_a(Feed::Activity)
    expect(ag.activities.first[:test]).to eq('foo')
  end
end
