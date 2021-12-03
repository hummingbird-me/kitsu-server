class Repost < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :post, required: true

  def stream_activity
    user.profile_feed.activities.new(
      object: post,
      nsfw: post.nsfw,
      foreign_id: self,
      verb: 'repost'
    )
  end
end
