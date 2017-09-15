# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: community_recommendation_follows
#
#  id                                  :integer          not null, primary key
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  community_recommendation_request_id :integer          indexed => [user_id]
#  user_id                             :integer          not null, indexed => [community_recommendation_request_id], indexed
#
# Indexes
#
#  index_community_recommendation_follows_on_user_and_request  (user_id,community_recommendation_request_id) UNIQUE
#  index_community_recommendation_follows_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_798884902b  (community_recommendation_request_id => community_recommendation_requests.id)
#  fk_rails_caa37f6fd5  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :community_recommendation_follow do
    user
    community_recommendation_request
  end
end
