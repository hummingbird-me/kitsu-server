require 'rails_helper'

RSpec.describe PostFollow, type: :model do
  subject { build(:post_follow) }

  it { should belong_to(:post).required }
  it { should belong_to(:user).required }
  it { should validate_uniqueness_of(:post).scoped_to(:user_id) }

  context 'which is on AMA that is closed' do
    it 'should not be valid' do
      post = create(:post)
      ama = create(:ama, original_post: post)
      ama.start_date = 6.hours.ago
      ama.end_date = ama.start_date + 1.hour
      ama.save
      post_follow = build(:post_follow, post: post)
      expect(post_follow).not_to be_valid
    end
  end
end
