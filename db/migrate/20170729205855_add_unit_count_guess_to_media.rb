class AddUnitCountGuessToMedia < ActiveRecord::Migration
  def change
    add_column :anime, :episode_count_guess, :integer
    add_column :manga, :chapter_count_guess, :integer
  end
end
