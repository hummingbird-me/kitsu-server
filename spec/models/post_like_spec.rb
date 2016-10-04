# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: post_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#
# Foreign Keys
#
#  fk_rails_a04bfa7e81  (post_id => posts.id)
#  fk_rails_d07653f350  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe PostLike, type: :model do
  subject { build(:post_like) }

  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
