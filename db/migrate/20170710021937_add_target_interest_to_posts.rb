class AddTargetInterestToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :target_interest, :string
  end
end
