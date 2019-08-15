class MakeAbbreviatedTitlesRequired < ActiveRecord::Migration
  using UpdateInBatches

  def change
    Anime.where(abbreviated_titles: nil).update_in_batches("abbreviated_titles = '{}'")
    change_column_null :anime, :abbreviated_titles, false
    change_column_default :anime, :abbreviated_titles, []

    Manga.where(abbreviated_titles: nil).update_in_batches("abbreviated_titles = '{}'")
    change_column_null :manga, :abbreviated_titles, false
    change_column_default :manga, :abbreviated_titles, []

    Drama.where(abbreviated_titles: nil).update_in_batches("abbreviated_titles = '{}'")
    change_column_null :dramas, :abbreviated_titles, false
    change_column_default :dramas, :abbreviated_titles, []
  end

  def down
    change_column_null :anime, :abbreviated_titles, true
    change_column_default :anime, :abbreviated_titles, nil

    change_column_null :manga, :abbreviated_titles, true
    change_column_default :manga, :abbreviated_titles, nil

    change_column_null :dramas, :abbreviated_titles, true
    change_column_default :dramas, :abbreviated_titles, nil
  end
end
