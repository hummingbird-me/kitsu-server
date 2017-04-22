class RegenerateStatService
  class << self
    def anime_genre_breakdown
      user_stat(:anime, 'Stat::AnimeGenreBreakdown')
    end

    def manga_genre_breakdown
      user_stat(:manga, 'Stat::MangaGenreBreakdown')
    end

    def anime_amount_consumed
      user_stat(:anime, 'Stat::AnimeAmountConsumed')
    end

    def manga_amount_consumed
      user_stat(:manga, 'Stat::MangaAmountConsumed')
    end

    def anime_favorite_year
      user_stat(:anime, 'Stat::AnimeFavoriteYear')
    end

    def manga_favorite_year
      user_stat(:manga, 'Stat::MangaFavoriteYear')

    def anime_activity_history
      user_stat(:anime, 'Stat::AnimeActivityHistory')
    end

    def manga_activity_history
      user_stat(:manga, 'Stat::MangaActivityHistory')
    end

    private

    def user_stat(media_column, stat_type)
      User.where(id: LibraryEntry.select(:user_id).by_kind(media_column))
          .find_each do |user|
            user.stats.find_or_initialize_by(type: stat_type).recalculate!
          end
    end
  end
end
