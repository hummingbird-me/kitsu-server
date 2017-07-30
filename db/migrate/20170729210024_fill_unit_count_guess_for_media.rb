class FillUnitCountGuessForMedia < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    Anime.where(episode_count: nil)
         .joins('INNER JOIN library_entries le ON le.anime_id = anime.id')
         .where('le.progress = (SELECT MAX(le.progress) FROM library_entries le WHERE le.media_id = anime.id)')
         .pluck('anime.id, le.progress').each do |a, pr|
           anime = Anime.find(a)
           anime.update_episode_count_guess([(pr + 1), anime.default_progress_limit].min)
         end
    Manga.where(chapter_count: nil)
         .joins('INNER JOIN library_entries le ON le.manga_id = manga.id')
         .where('le.progress = (SELECT MAX(le.progress) FROM library_entries le WHERE le.media_id = manga.id)')
         .pluck('manga.id, le.progress').each do |m, pr|
           manga = Manga.find(m)
           manga.update_chapter_count_guess([(pr + 1), manga.default_progress_limit].min)
         end
  end
end
