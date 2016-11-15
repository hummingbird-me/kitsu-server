class FeedCommentingBadge < Badge
  on Comment
  progress { Comment.where(user: user).count }

  rank 1 do
    title 'Smooth'
    description 'First comment! It seems you know how to break the ice.'
    bestow_when 1
  end

  rank 2 do
    title 'Chatterbox'
    description 'You really know your way around a conversation.' \
      ' You\'ve already made 5 comments!'
    bestow_when 5
  end

  rank 3 do
    title 'Motormouth'
    description 'You certainly have a knack for conversation. 50 replies!'
    bestow_when 50
  end

  rank 4 do
    title 'Opinionated'
    description '100 replies. You\'re mastering the art of making' \
      ' people engage. Good work!'
    bestow_when 100
  end

  rank 5 do
    title 'Social Animal'
    description 'With 500 comments, one could say you\'re the life' \
      ' of the party. Keep it up!'
    bestow_when 500
  end

  rank 6 do
    title 'Trendsetter'
    description 'You speak and people listen. Congratulations' \
      'on 2000 comments!'
    bestow_when 2000
  end

  rank 7 do
    title 'Loquacious'
    description 'With over 9000 comments, you are an unstoppable' \
      ' force of community discussion.end'
    bestow_when 9000
  end
end
