class CleanUpBestowments < ActiveRecord::Migration
  def change
    change_table :bestowments do |t|
      t.rename :bestowed_at, :earned_at
      t.remove :description
      t.remove :title
      t.index %i[user_id badge_id rank], unique: true
    end
  end
end
