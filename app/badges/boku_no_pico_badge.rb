class BokuNoPicoBadge < Badge
  on LibraryEntry
  hidden

  title 'Le Meme'
  description 'My ochinchin feels funny...'
  bestow_when do
    user.library_entries.completed.for(Anime.find('boku-no-pico')).exists?
  end
end
