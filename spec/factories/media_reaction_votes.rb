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

FactoryGirl.define do
  factory :media_reaction_vote do
    user
    media_reaction
  end
end
