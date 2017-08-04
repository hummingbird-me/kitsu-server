class AddDefaultsForReactionSkipped < ActiveRecord::Migration
  def change
    change_column_null :library_entries, :reaction_skipped, false
    change_column_default :library_entries, :reaction_skipped, 0
  end
end
