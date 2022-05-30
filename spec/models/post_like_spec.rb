require 'rails_helper'

RSpec.describe PostLike, type: :model do
  subject { build(:post_like) }

  it { is_expected.to belong_to(:post).counter_cache(true).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to validate_uniqueness_of(:post).scoped_to(:user_id) }

  context 'which is on AMA that is closed' do
    it 'is not valid' do
      post = create(:post)
      ama = create(:ama, original_post: post)
      ama.start_date = 6.hours.ago
      ama.end_date = ama.start_date + 1.hour
      ama.save
      post_like = build(:post_like, post: post)
      expect(post_like).not_to be_valid
    end
  end
end
