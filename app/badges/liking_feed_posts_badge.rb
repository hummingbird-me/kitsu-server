class LikingFeedPostsBadge < Badge
  on PostLike
  progress { PostLike.where(user: user).count }

  # rank 1 do
  #   title 'Anime Pursuit'
  #   description 'Anime goes beyond daily life'
  #   bestow_when 1
  # end

  # rank 2 do
  #   title 'Weeb Trash'
  #   description 'Anime is your life'
  #   bestow_when 10
  # end

  RANKS = {
    1 => {
      title: 'Anime Pursuit',
      description: 'Anime goes beyond daily life',
      bestow_when: 1
    },
    2 => {
      title: 'Weeb Trash',
      description: 'Anime is your life',
      bestow_when: 10
    }
  }
end

LikingFeedPostsBadge.new(User.first)
