class TheAdventureBeginBadge < Badge
  bestow_when { user.finished? }
end
