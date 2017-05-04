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

FactoryGirl.define do
  factory :post_follow do
    association :user, factory: :user, strategy: :build
    association :post, factory: :post, strategy: :build
  end
end
