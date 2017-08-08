class FillUnitCountGuessForMedia < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    LibraryEntry.where(anime_id: Anime.where(episode_count: nil).ids)
                .group(:anime_id)
                .maximum(:progress)
                .each do |a, pr|
                  anime = Anime.find(a)
                  anime.update_unit_count_guess([(pr + 1), anime.default_progress_limit].min)
                end
    LibraryEntry.where(manga_id: Manga.where(chapters_count: nil).ids)
                .group(:manga_id)
                .maximum(:progress)
                .each do |a, pr|
                  manga = Manga.find(m)
                  manga.update_unit_count_guess([(pr + 1), manga.default_progress_limit].min)
                end
  end
end
