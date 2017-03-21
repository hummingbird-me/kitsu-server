class RegenerateStatService
  def anime_genre_breakdown
    User.where(id: LibraryEntry.select(:user_id)).find_each do |user|
      user.stats.find_by(type: 'Stat::AnimeGenreBreakdown').recalculate!
    end
  end
end
