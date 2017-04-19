namespace :kitsu do
  task user_stats: :environment do
    klass = RegenerateStatService

    # Genre Breakdown
    klass.anime_genre_breakdown
    klass.manga_genre_breakdown

    # Amount Watched/Read
    klass.anime_amount_consumed
    klass.manga_amount_consumed

    # Favorite Year
    klass.anime_favorite_year
    klass.manga_favorite_year
  end
end
