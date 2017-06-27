class ConsecutiveDaysBadge < Badge
  progress { user.consecutive_days }

  rank(1) { bestow_when 3 }
  rank(2) { bestow_when 30 }
  rank(3) { bestow_when 100 }
  rank(4) { bestow_when 365 }
end
