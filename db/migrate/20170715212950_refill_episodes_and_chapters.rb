class RefillEpisodesAndChapters < ActiveRecord::Migration
  self.disable_ddl_transaction!
  def change
    Anime.joins('LEFT OUTER JOIN episodes ON episodes.media_id = anime.id').distinct
         .group(:id).having('count(episodes) < anime.episode_count')
         .each { |a| a.episodes.create_defaults(a.episode_count) }

    Manga.joins('LEFT OUTER JOIN chapters ON chapters.manga_id = manga.id').distinct
         .group(:id).having('count(chapters) < manga.chapter_count')
         .each { |m| m.chapters.create_defaults(m.chapter_count) }
  end
end
