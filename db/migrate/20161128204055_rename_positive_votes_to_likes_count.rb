class RenamePositiveVotesToLikesCount < ActiveRecord::Migration
  def change
    rename_column :quotes, :positive_votes, :likes_count
  end
end
