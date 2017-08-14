# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: post_follows
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          indexed
#  user_id    :integer          indexed
#
# Indexes
#
#  index_post_follows_on_post_id  (post_id)
#  index_post_follows_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_8cdaf33e9c  (user_id => users.id)
#  fk_rails_afb3620fdd  (post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe PostFollow, type: :model do
  subject { build(:post_follow) }

  it { should belong_to(:post) }
  it { should belong_to(:user) }
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
