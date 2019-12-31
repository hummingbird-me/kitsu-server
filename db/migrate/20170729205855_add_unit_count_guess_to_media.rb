class AddUnitCountGuessToMedia < ActiveRecord::Migration[4.2]
  def change
    add_column :anime, :episode_count_guess, :integer
    add_column :manga, :chapter_count_guess, :integer
  end
end
