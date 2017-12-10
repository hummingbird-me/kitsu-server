class CreateCommunityRecommendationRequests < ActiveRecord::Migration
  def change
    create_table :community_recommendation_requests do |t|
      t.references :user, index: true, null: false, foreign_key: true, required: true
      t.string :title, required: true
      t.string :description, required: true
      t.timestamps null: false
    end
  end
end
