class AddRelativeNumberToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :relative_number, :integer
  end
end
