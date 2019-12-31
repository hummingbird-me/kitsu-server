class AddPastUsernamesToUsers < ActiveRecord::Migration[4.2]
  def change
    change_table :users do |t|
      t.string :past_names, array: true, default: [], null: false
    end
  end
end
