class TheAdventureBeginBadge < Badge
  on User
  title 'The Adventure Begins'
  description 'You\'ve completed all the steps to set-up your Kitsu' \
    ' account. Now the fun can begin!'
  bestow_when { user.finished? }
end
