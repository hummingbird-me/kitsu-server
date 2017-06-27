class HummingbirdBadge < Badge
  # Hummingbird finally died on December 12, 2016
  bestow_when { user.created_at < Date.new(2016, 12, 12) }
end
