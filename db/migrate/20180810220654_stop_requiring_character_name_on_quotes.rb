class StopRequiringCharacterNameOnQuotes < ActiveRecord::Migration
  def change
    change_column_null :quotes, :character_name, true
  end
end
