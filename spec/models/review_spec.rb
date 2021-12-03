require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { build(:user, id: 1) }

  subject { build(:review, user: user) }
  it { should have_many(:likes).class_name('ReviewLike') }
  it { should belong_to(:media).required }
  it 'should validate uniqueness per media and user' do
    subject.save!
    expect(subject).to validate_uniqueness_of(:media_id).scoped_to(:user_id)
  end
  it { should belong_to(:user).counter_cache(true).required }
  it { should belong_to(:library_entry).required }
  it { should validate_presence_of(:content) }

  describe '#steam_activity' do
    it 'publishes the activity to the user\'s media feed' do
      expect(subject.stream_activity.feed).to eq(subject.user.profile_feed)
    end

    it 'copies the activity to the media\'s media feed' do
      expect(subject.stream_activity[:to]).to(
        include(subject.media.feed)
      )
    end
  end
end
