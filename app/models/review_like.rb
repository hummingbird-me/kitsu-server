# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: review_likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  review_id  :integer          not null
#  user_id    :integer          not null
#
# Foreign Keys
#
#  fk_rails_2f5b7cb84c  (user_id => users.id)
#  fk_rails_e06d0d2851  (review_id => reviews.id)
#
# rubocop:enable Metrics/LineLength

class ReviewLike < ApplicationRecord
  belongs_to :review, required: true
  belongs_to :user, required: true
end
