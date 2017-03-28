namespace :kitsu do
  task :user_stats => :environment do
    klass = RegenerateStatService

    klass.anime_genre_breakdown
    klass.anime_amount_watched
  end
end
