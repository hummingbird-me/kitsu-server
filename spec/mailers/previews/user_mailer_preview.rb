class UserMailerPreview < ActionMailer::Preview
  def initialize
    Faker::Config.random = Random.new
    @user = User.new(
      name: 'Joe Blow',
      email: Faker::Internet.email,
      id: 2323,
      slug: 'joe_blow',
      password: Faker::Internet.password
    )
    @user_post = Post.new(
      content: Faker::Lorem.sentence,
      user: @user,
      id: 1
    )
    @user2 = User.new(
      name: 'Blow Joe',
      id: 2,
      slug: 'blow_joe',
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )
    @user_post2 = Post.new(
      content: Faker::Lorem.sentence,
      user: @user2,
      id: 2
    )
    @post_like = PostLike.new(
      user: @user2,
      post: @user_post
    )
    @comment = Comment.new(
      user: @user2,
      post: @user_post,
      content: Faker::Lorem.sentence,
      id: 1
    )
  end

  def confirmation
    UserMailer.confirmation(@user)
  end

  def onboarding_follow_users
    UserMailer.onboarding_follow_users(@user)
  end

  def reengagement_never
    UserMailer.reengagement(@user, 0)
  end

  def reengagement_nine
    UserMailer.reengagement(@user, 9)
  end

  def reengagement_eighteen
    UserMailer.reengagement(@user, 18)
  end

  def reengagement_twentyeight
    UserMailer.reengagement(@user, 28)
  end

  def notification_first_like
    UserMailer.notification(@user, 1, [@user2], 'related_post_likes': [@post_like])
  end

  def notification_liked
    UserMailer.notification(@user, 2, [@user2], 'related_post_likes': [@post_like])
  end

  def notification_replied
    UserMailer.notification(@user, 3, [@user2], 'related_post_replies_users': [@comment])
  end

  def notification_mentioned
    meta_data = { 'mention_posts': [@user_post2], 'mentioned_comments': [@comment] }
    UserMailer.notification(@user, 4, [@user2], meta_data)
  end

  def notification_followed
    UserMailer.notification(@user, 5, [@user2], 'related_follower': [@user2])
  end

  def notification_posted
    UserMailer.notification(@user, 6, [@user2], 'related_profile_posts': [@user_post2])
  end

  def notification_reaction
    media_reaction = MediaReaction.new(
      user: @user,
      reaction: Faker::Lorem.sentence[0, 140],
      media: Anime.first,
      id: 1
    )
    media_reaction_vote = MediaReactionVote.new(
      user: @user2,
      media_reaction: media_reaction
    )
    UserMailer.notification(
      @user,
      7,
      [@user2],
      'related_reaction_votes': [media_reaction_vote]
    )
  end
end
