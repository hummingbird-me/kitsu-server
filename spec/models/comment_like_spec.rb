require 'rails_helper'

RSpec.describe CommentLike, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:comment).counter_cache(:likes_count).required }

  context 'which is on AMA that is closed' do
    it 'is not valid' do
      post = create(:post)
      ama = create(:ama, original_post: post)
      comment = build(:comment, post: post)
      ama.start_date = 6.hours.ago
      ama.end_date = ama.start_date + 1.hour
      ama.save
      comment_like = build(:comment_like, comment: comment)
      expect(comment_like).not_to be_valid
    end
  end
end
