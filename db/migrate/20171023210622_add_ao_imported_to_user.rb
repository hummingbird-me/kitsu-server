class AddAoImportedToUser < ActiveRecord::Migration
  def change
    add_column :users, :ao_imported, :string
  end
end
