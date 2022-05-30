class MediaReactionVote < ApplicationRecord
  include WithActivity

  belongs_to :media_reaction, optional: false
  belongs_to :user, optional: false

  counter_culture :media_reaction, column_name: 'up_votes_count'

  validate :vote_on_self

  def vote_on_self
    errors.add(:user, 'You can not vote for yourself') if media_reaction&.user == user
  end

  def stream_activity
    media_reaction.user.notifications.activities.new(
      verb: 'vote',
      target: media_reaction
    )
  end
end
