class RenameOrderOnUploads < ActiveRecord::Migration
  def change
  	rename_column :uploads, :order, :upload_order
  end
end
