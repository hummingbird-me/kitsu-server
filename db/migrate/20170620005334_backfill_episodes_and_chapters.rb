class BackfillEpisodesAndChapters < ActiveRecord::Migration
  def change
    Anime.joins(:episodes)
         .group('anime.id')
         .having('count(episodes) < anime.episode_count')
         .each { |a| a.sync_episodes }

    Manga.joins(:chapters)
         .group('manga.id')
         .having('count(chapters) < manga.chapter_count')
         .each { |m| m.sync_chapters }
  end
end
