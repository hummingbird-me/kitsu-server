class Repost < ApplicationRecord
  include WithActivity

  belongs_to :user, optional: false
  belongs_to :post, optional: false

  def stream_activity
    user.profile_feed.activities.new(
      object: post,
      nsfw: post.nsfw,
      foreign_id: self,
      verb: 'repost'
    )
  end
end
