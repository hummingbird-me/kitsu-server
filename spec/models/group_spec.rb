require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { build(:group) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
  it { should define_enum_for(:privacy) }
  it do
    should have_many(:members).class_name('GroupMember').dependent(:destroy)
  end
  it do
    should have_many(:neighbors).class_name('GroupNeighbor').dependent(:destroy)
                                .with_foreign_key('source_id')
  end
  it do
    should have_many(:tickets).class_name('GroupTicket').dependent(:destroy)
  end
  it do
    should have_many(:invites).class_name('GroupInvite').dependent(:destroy)
  end
  it do
    should have_many(:reports).class_name('GroupReport').dependent(:destroy)
  end
  it { should have_many(:leader_chat_messages).dependent(:destroy) }
  it { should have_many(:bans).class_name('GroupBan').dependent(:destroy) }
  it do
    should have_many(:action_logs).class_name('GroupActionLog').dependent(:destroy)
  end
  it { should belong_to(:category).class_name('GroupCategory').required }
  it { should validate_length_of(:tagline).is_at_most(60) }

  it 'should set up the feed on create' do
    feed = double('GroupFeed')
    allow(subject).to receive(:feed).and_return(feed)
    expect(feed).to receive(:setup!)
    subject.save!
  end
end
