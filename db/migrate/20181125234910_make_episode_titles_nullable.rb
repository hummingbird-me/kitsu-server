class MakeEpisodeTitlesNullable < ActiveRecord::Migration[4.2]
  def up
    change_column_null :episodes, :canonical_title, true
    change_column_default :episodes, :canonical_title, nil
    change_column_null :chapters, :canonical_title, true
    change_column_default :chapters, :canonical_title, nil
  end

  def down
    change_column_null :episodes, :canonical_title, false
    change_column_default :episodes, :canonical_title, 'en_jp'
    change_column_null :chapters, :canonical_title, false
    change_column_default :chapters, :canonical_title, 'en_jp'
  end
end
