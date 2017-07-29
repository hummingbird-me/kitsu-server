class AddAbsoluteNumberToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :absolute_number, :integer
  end
end
