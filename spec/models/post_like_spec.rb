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
    let(:ama) { build(:ama, start_time: 6.hours.ago) }
    let(:post) { build(:post, ama: ama) }
    let(:post_like) { build(:post_like, post: post) }

    subject { post_like }

    it 'should not be valid' do
      should_not be_valid
    end
  end
end
