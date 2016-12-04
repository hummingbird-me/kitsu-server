class ConsecutiveDaysBadge < Badge
  on User
  progress { user.consecutive_days }

  rank 1 do
    title 'Filthy Casual'
    description 'You\'ve visited Kitsu every day for 3 consecutive' \
      ' days. Happy to have you here!'
    bestow_when 3
  end

  rank 2 do
    title 'Enthusiast'
    description 'Hey, we\'ve got a good thing going. You\'ve visited' \
      ' Kitsu every day for 30 consecutive days.'
    bestow_when 30
  end

  rank 3 do
    title 'Fanatic'
    description 'You\'ve visited Kitsu every day for 100 consecutive' \
      ' days. At this point, we\'re basically family.'
    bestow_when 100
  end

  rank 4 do
    title 'Addicted'
    description 'The bards will sing songs of your dedication. You\'ve' \
      ' visited Kitsu every day for 365 consecutive days. We\'ve' \
      ' experienced a lot together!'
    bestow_when 365
  end
end
