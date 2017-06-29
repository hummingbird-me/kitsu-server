class TheAdventureBeginsBadge < Badge
  bestow_when { user.email.present? && user.bio.present? }
end
