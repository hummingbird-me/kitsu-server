# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: posts
#
#  id                       :integer          not null, primary key
#  blocked                  :boolean          default(FALSE), not null
#  comments_count           :integer          default(0), not null
#  content                  :text             not null
#  content_formatted        :text             not null
#  deleted_at               :datetime         indexed
#  edited_at                :datetime
#  media_type               :string           indexed => [media_id]
#  embed                    :jsonb
#  nsfw                     :boolean          default(FALSE), not null
#  post_likes_count         :integer          default(0), not null
#  spoiled_unit_type        :string
#  spoiler                  :boolean          default(FALSE), not null
#  target_interest          :string
#  top_level_comments_count :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  community_recommendation_id :integer          indexed
#  media_id                 :integer          indexed => [media_type]
#  spoiled_unit_id          :integer
#  target_group_id          :integer
#  target_user_id           :integer
#  user_id                  :integer          not null
#
# Indexes
#
#  index_posts_on_community_recommendation_id  (community_recommendation_id)
#  index_posts_on_deleted_at      (deleted_at)
#  posts_media_type_media_id_idx  (media_type,media_id)
#
# Foreign Keys
#
#  fk_rails_5b5ddfd518  (user_id => users.id)
#  fk_rails_6fac2de613  (target_user_id => users.id)
#  fk_rails_f82460b586  (community_recommendation_id => community_recommendations.id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :post do
    user
    content { Faker::Lorem.sentence }
  end
end
