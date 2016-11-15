class LikingFeedPostsBadge < Badge
  on PostLike
  progress { PostLike.where(user: user).count }

  rank 1 do
    title 'First like'
    description 'You\'ve liked a comment, we like you.'
    bestow_when 1
  end

  rank 2 do
    title 'People Person'
    description '10 likes given! We love that you are spreading' \
      ' the love across the community. You\'re great!'
    bestow_when 10
  end

  rank 3 do
    title 'Passionate'
    description 'You\'re becoming uniquely passionate about Kitsu' \
      ' and the community. 50 likes given!'
    bestow_when 50
  end

  rank 4 do
    title 'Promoter'
    description 'Dang, look at you. With 100 likes spread across the' \
      ' community, you definitely have an eye for quality.'
    bestow_when 100
  end

  rank 5 do
    title 'Patron'
    description 'That\'s 500 good reasons to keep engaging with this' \
      ' community. We love your enthusiasm!'
    bestow_when 500
  end

  rank 6 do
    title 'Familiar Face'
    description '2000 likes?! You have a lot of love to give.' \
      ' You\'re quickly becoming a recognizable face around here.'
    bestow_when 2000
  end

  rank 7 do
    title 'Yandere'
    description '9000 likes... that\'s a whole lot of love for' \
      ' the community. Perhaps too much love...'
    bestow_when 9000
  end
end
