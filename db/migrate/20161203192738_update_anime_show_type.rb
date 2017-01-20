class UpdateAnimeShowType < ActiveRecord::Migration
  class Anime < ActiveRecord::Base; end

  def change
    Anime.where(show_type: nil).update_all(show_type: 1)
    change_column_null :anime, :show_type, false
    change_column_default :anime, :show_type, 1
  end
end
