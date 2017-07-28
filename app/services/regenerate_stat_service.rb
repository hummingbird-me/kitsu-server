class RegenerateStatService
  class << self
    def anime_category_breakdown
      user_stat(:anime, 'Stat::AnimeCategoryBreakdown')
    end

    def manga_category_breakdown
      user_stat(:manga, 'Stat::MangaCategoryBreakdown')
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
    end

    def anime_activity_history
      user_stat(:anime, 'Stat::AnimeActivityHistory')
    end

    def manga_activity_history
      user_stat(:manga, 'Stat::MangaActivityHistory')
    end

    private

    def user_stat(media_column, stat_type)
      users = User.where(id: LibraryEntry.select(:user_id).by_kind(media_column))
      bar = progress_bar(stat_type, users.count)

      users.find_each do |user|
        bar.increment
        user.stats.find_or_initialize_by(type: stat_type).recalculate!
      end
    end

    def progress_bar(title, count)
      ProgressBar.create(
        title: title,
        total: count,
        output: STDERR,
        format: '%a (%p%%) |%B| %E %t'
      )
    end
  end
end
