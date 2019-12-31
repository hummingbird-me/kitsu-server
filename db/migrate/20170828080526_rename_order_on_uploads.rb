class RenameOrderOnUploads < ActiveRecord::Migration[4.2]
  def change
  	rename_column :uploads, :order, :upload_order
  end
end
