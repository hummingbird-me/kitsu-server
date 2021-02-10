# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: community_recommendations
#
#  id                                  :integer          not null, primary key
#  media_type                          :string           indexed => [media_id], indexed => [media_id]
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  anime_id                            :integer          indexed
#  community_recommendation_request_id :integer
#  drama_id                            :integer          indexed
#  manga_id                            :integer          indexed
#  media_id                            :integer          indexed => [media_type], indexed => [media_type]
#
# Indexes
#
#  index_community_recommendations_on_anime_id                 (anime_id)
#  index_community_recommendations_on_drama_id                 (drama_id)
#  index_community_recommendations_on_manga_id                 (manga_id)
#  index_community_recommendations_on_media_id_and_media_type  (media_id,media_type) UNIQUE
#  index_community_recommendations_on_media_type_and_media_id  (media_type,media_id)
#
# Foreign Keys
#
#  fk_rails_0a990e1c9a  (drama_id => dramas.id)
#  fk_rails_31cb227f33  (community_recommendation_request_id => community_recommendation_requests.id)
#  fk_rails_6181ed129e  (manga_id => manga.id)
#  fk_rails_d42c776f05  (anime_id => anime.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe CommunityRecommendation, type: :model do
  subject { build(:community_recommendation) }

  it { should belong_to(:anime).optional }
  it { should belong_to(:manga).optional }
  it { should belong_to(:drama).optional }
  it { should have_many(:reasons) }
  it { should belong_to(:community_recommendation_request).required }
end
