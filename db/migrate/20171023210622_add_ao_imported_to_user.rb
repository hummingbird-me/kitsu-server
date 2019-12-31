class AddAoImportedToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ao_imported, :string
  end
end
