class AddRelativeNumberToEpisodes < ActiveRecord::Migration[4.2]
  def change
    add_column :episodes, :relative_number, :integer
  end
end
