# == Schema Information
#
# Table name: review_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  review_id  :integer          not null, indexed
#  user_id    :integer          not null, indexed
#
# Indexes
#
#  index_review_likes_on_review_id  (review_id)
#  index_review_likes_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_2f5b7cb84c  (user_id => users.id)
#

FactoryGirl.define do
  factory :review_like do
    review
    user
  end
end
