namespace :kitsu do
  task user_stats: :environment do
    klass = RegenerateStatService

    # Category Breakdown
    klass.anime_category_breakdown
    klass.manga_category_breakdown

    # Amount Watched/Read
    klass.anime_amount_consumed
    klass.manga_amount_consumed

    # Favorite Year
    klass.anime_favorite_year
    klass.manga_favorite_year

    # Activity History
    # klass.anime_activity_history
    # klass.manga_activity_history
  end
end
