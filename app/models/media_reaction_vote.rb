# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_reaction_votes
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  media_reaction_id :integer          indexed, indexed => [user_id]
#  user_id           :integer          indexed => [media_reaction_id], indexed
#
# Indexes
#
#  index_media_reaction_votes_on_media_reaction_id              (media_reaction_id)
#  index_media_reaction_votes_on_media_reaction_id_and_user_id  (media_reaction_id,user_id) UNIQUE
#  index_media_reaction_votes_on_user_id                        (user_id)
#
# Foreign Keys
#
#  fk_rails_4d07eecb67  (user_id => users.id)
#  fk_rails_dab3468b92  (media_reaction_id => media_reactions.id)
#
# rubocop:enable Metrics/LineLength

class MediaReactionVote < ApplicationRecord
  include WithActivity

  belongs_to :media_reaction, required: true
  belongs_to :user, required: true

  counter_culture :media_reaction, column_name: 'up_votes_count'

  validate :vote_on_self

  def vote_on_self
    errors.add(:user, 'You can not vote for yourself') if media_reaction.user == user
  end

  def stream_activity
    media_reaction.user.notifications.activities.new(
      verb: 'vote',
      target: media_reaction
    )
  end
end
