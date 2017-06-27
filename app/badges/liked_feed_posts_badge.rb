class LikedFeedPostsBadge < Badge
  progress { user.posts.order(post_likes_count: :desc).first.post_likes_count }

  rank(1) { bestow_when 1 }
  rank(2) { bestow_when 5 }
  rank(3) { bestow_when 10 }
  rank(4) { bestow_when 25 }
  rank(5) { bestow_when 50 }
  rank(6) { bestow_when 100 }
  rank(7) { bestow_when 500 }
  rank(8) { bestow_when 1000 }
end
