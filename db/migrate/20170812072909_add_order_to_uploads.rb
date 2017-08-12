class AddOrderToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :order, :integer
  end
end
