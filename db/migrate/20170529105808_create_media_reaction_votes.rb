class CreateMediaReactionVotes < ActiveRecord::Migration
  def change
    create_table :media_reaction_votes do |t|
      t.references :user, index: true, foreign_key: true, required: true
      t.references :media_reactions, index: true, foreign_key: true, required: true
      t.timestamps null: false
    end
  end
end
