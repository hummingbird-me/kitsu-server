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

require 'rails_helper'

RSpec.describe PostLike, type: :model do
  subject { build(:post_like) }

  it { should belong_to(:post).counter_cache(true) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:post).scoped_to(:user_id) }
end
