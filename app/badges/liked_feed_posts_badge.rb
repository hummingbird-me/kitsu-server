class LikedFeedPostsBadge < Badge
  on Post, :touch
  progress do
    Post.where(user: user).map { |post| post.post_likes.count }.max.to_i
  end

  rank 1 do
    title 'One of us'
    description 'It\'s official, you\'re in! You received your' \
      ' first like from a member of the community.'
    bestow_when 1
  end

  rank 2 do
    title 'High Five'
    description 'Give me 5! Your post has received 5 likes. Keep it up!'
    bestow_when 5
  end

  rank 3 do
    title 'Group Hug'
    description 'Please accept a warm hug from the community.' \
      ' Your post has earned 10 likes from the community.'
    bestow_when 10
  end

  rank 4 do
    title 'Bravo'
    description 'You\'re gaining recognition. 25 likes on your post!'
    bestow_when 25
  end

  rank 5 do
    title 'Applause'
    description 'You\'ve definitely gained an audience. We applaud' \
      ' you for 50 likes on your post.'
    bestow_when 50
  end

  rank 6 do
    title 'Fan Club'
    description 'You seem to have a group of followers! Your post' \
      ' has received 100 likes.'
    bestow_when 100
  end

  rank 7 do
    title 'Wave of Cheers'
    description 'Can you hear it? The community is cheering you' \
      ' on. Your post has reached 500 likes.'
    bestow_when 500
  end

  rank 8 do
    title 'Celebrity'
    description 'You\'re a community celebrity with over 1000 likes' \
      ' on a single post. Can we have an autograph?'
    bestow_when 1000
  end
end
