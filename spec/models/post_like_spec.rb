# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: post_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null, indexed
#  user_id    :integer          not null
#
# Indexes
#
#  index_post_likes_on_post_id  (post_id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe PostLike, type: :model do
  subject { build(:post_like) }

  it { should belong_to(:post).counter_cache(true) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:post).scoped_to(:user_id) }

  context 'which is on AMA that is closed' do
    it 'should not be valid' do
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
