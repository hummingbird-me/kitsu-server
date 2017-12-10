class AddCommunityRecommendationsIdToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :community_recommendation, index: true, foreign_key: true, null: true
  end
end
