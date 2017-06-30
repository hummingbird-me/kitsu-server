class BackfillEpisodesAndChapters < ActiveRecord::Migration
  self.disable_ddl_transaction!
  def change
    Anime.joins(:episodes)
         .group('anime.id')
         .having('count(episodes) < anime.episode_count')
         .each { |a| a.episodes.create_defaults(a.episode_count) }

    Manga.joins(:chapters)
         .group('manga.id')
         .having('count(chapters) < manga.chapter_count')
         .each { |m| m.chapters.create_defaults(m.chapter_count) }
  end
end
