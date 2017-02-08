class RenameVersionsToWikiVersions < ActiveRecord::Migration
  def change
    rename_table :versions, :wiki_versions
  end
end
