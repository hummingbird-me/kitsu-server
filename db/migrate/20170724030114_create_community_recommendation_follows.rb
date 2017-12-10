class CreateCommunityRecommendationFollows < ActiveRecord::Migration
  def change
    create_table :community_recommendation_follows do |t|
      t.references :user, index: true, null: false, foreign_key: true, required: true
      t.references :community_recommendation_request, foreign_key: true, required: true
      t.index %i[user_id community_recommendation_request_id],
        name: 'index_community_recommendation_follows_on_user_and_request', unique: true
      t.timestamps null: false
    end
  end
end
