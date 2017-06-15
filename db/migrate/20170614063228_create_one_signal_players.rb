class CreateOneSignalPlayers < ActiveRecord::Migration
  def change
    create_table :one_signal_players do |t|
      t.references :user, index: true, foreign_key: true
      t.string :player_id
      t.integer :platform

      t.timestamps null: false
    end
  end
end
