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
# Foreign Keys
#
#  fk_rails_a04bfa7e81  (post_id => posts.id)
#  fk_rails_d07653f350  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :post_like do
    post
    user
  end
end
