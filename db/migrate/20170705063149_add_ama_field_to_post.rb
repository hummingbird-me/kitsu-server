class AddAmaFieldToPost < ActiveRecord::Migration
  def change
  	add_reference :posts, :ama, index: true, foreign_key: true
  end
end
