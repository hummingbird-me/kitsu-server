class CreateCommunityRecommendations < ActiveRecord::Migration
  def change
    create_table :community_recommendations do |t|
      t.references :media, index: true, polymorphic: true, required: true
      t.references :anime, index: true, null: true, foreign_key: true
      t.references :drama, index: true, null: true, foreign_key: true
      t.references :manga, index: true, null: true, foreign_key: true
      t.references :community_recommendation_request, foreign_key: true, required: true
      t.index %i[media_id media_type], unique: true
      t.timestamps null: false
    end
  end
end
