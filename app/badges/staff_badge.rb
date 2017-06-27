class StaffBadge < Badge
  bestow_when { user.title == 'Staff' }
end
