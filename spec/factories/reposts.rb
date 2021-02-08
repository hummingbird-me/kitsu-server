# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: reposts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null, indexed
#  user_id    :integer          not null, indexed
#
# Indexes
#
#  index_reposts_on_post_id  (post_id)
#  index_reposts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_39c15eb0c7  (post_id => posts.id)
#  fk_rails_ed3b6ef3d8  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryBot.define do
  factory :repost do
    user
    post
  end
end
