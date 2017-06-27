class FeedCommentingBadge < Badge
  progress { Comment.where(user: user).count }

  rank(1) { bestow_when 1 }
  rank(2) { bestow_when 5 }
  rank(4) { bestow_when 100 }
  rank(5) { bestow_when 500 }
  rank(6) { bestow_when 2000 }
  rank(7) { bestow_when 9000 }
end
