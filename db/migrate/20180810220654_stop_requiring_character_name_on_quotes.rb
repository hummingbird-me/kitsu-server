class StopRequiringCharacterNameOnQuotes < ActiveRecord::Migration[4.2]
  def change
    change_column_null :quotes, :character_name, true
  end
end
