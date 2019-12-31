class AddCommunityRecommendationsIdToPosts < ActiveRecord::Migration[4.2]
  def change
    add_reference :posts, :community_recommendation, index: true, foreign_key: true, null: true
  end
end
