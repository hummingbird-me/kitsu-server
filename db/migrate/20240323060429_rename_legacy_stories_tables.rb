class RenameLegacyStoriesTables < ActiveRecord::Migration[6.1]
  def change
    rename_table :stories, :legacy_stories
    rename_table :substories, :legacy_substories
  end
end
