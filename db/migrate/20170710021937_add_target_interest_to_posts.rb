class AddTargetInterestToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :target_interest, :string
  end
end
