# frozen_string_literal: true

class Types::Story::FollowStory < Types::BaseObject
  implements Types::Interface::Story

  field :follower, Types::Profile, null: false

  def follower
    object.follow.follower
  end

  field :following, Types::Profile, null: false

  def following
    object.follow.followed
  end
end
