# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: comment_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :integer          indexed, indexed => [user_id]
#  user_id    :integer          indexed, indexed => [comment_id]
#
# Indexes
#
#  index_comment_likes_on_comment_id              (comment_id)
#  index_comment_likes_on_user_id                 (user_id)
#  index_comment_likes_on_user_id_and_comment_id  (user_id,comment_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_c28a479c60  (comment_id => comments.id)
#  fk_rails_efcc5b56dc  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe CommentLike, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:comment).counter_cache(:likes_count) }

  context 'which is on AMA that is closed' do
    it 'should not be valid' do
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
