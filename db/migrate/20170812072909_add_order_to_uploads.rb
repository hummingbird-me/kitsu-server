class AddOrderToUploads < ActiveRecord::Migration[4.2]
  def change
    add_column :uploads, :order, :integer
  end
end
