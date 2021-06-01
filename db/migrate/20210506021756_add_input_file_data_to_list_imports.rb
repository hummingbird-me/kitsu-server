class AddInputFileDataToListImports < ActiveRecord::Migration[5.2]
  def change
    add_column :list_imports, :input_file_data, :jsonb
  end
end
