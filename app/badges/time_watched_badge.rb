class TimeWatchedBadge < Badge
  on LibraryEntry
  progress { user.life_spent_on_anime }

  rank 1 do
    title 'Anime Pursuit'
    description 'Anime goes beyond daily life'
    bestow_when 1.month
  end
  rank 2 do
    title 'Weeb Trash'
    description 'Anime is your life'
    bestow_when 3.months
  end
end
