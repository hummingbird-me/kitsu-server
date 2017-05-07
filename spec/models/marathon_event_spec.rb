# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: marathon_events
#
#  id          :integer          not null, primary key
#  event       :integer          not null
#  status      :integer
#  unit_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  marathon_id :integer          not null
#  unit_id     :integer
#
# Foreign Keys
#
#  fk_rails_43eaffb81b  (marathon_id => marathons.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe MarathonEvent, type: :model do
  subject { build(:marathon_event) }
  it { should define_enum_for(:event).with(%i[added updated consumed]) }
  it { should define_enum_for(:status).with(LibraryEntry.statuses) }

  it { should validate_presence_of(:event) }

  context 'with event=changed' do
    subject { build(:marathon_event, event: :updated)}
    it { should validate_presence_of(:status) }
  end

  context 'without event=changed' do
    subject { build(:marathon_event, event: :consumed) }
    it { should_not validate_presence_of(:status) }
  end

  it 'should publish to the user\'s media feed' do
    expect(subject.stream_activity.feed).to eq(subject.user.media_feed)
  end

  it 'should have an activity with media\'s media feed in "to" list' do
    activity = subject.stream_activity.as_json.with_indifferent_access
    expect(activity[:to]).to include(subject.media.media_feed.stream_id)
  end
end
