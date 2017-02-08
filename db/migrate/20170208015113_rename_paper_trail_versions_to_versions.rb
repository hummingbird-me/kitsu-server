class RenamePaperTrailVersionsToVersions < ActiveRecord::Migration
  def change
    rename_table :paper_trail_versions, :versions
  end
end
