class MediaReactionVoteResource < BaseResource
  attributes :created_at, :updated_at

  has_one :media_reaction
  has_one :user

  filter :media_reaction_id
  filter :user_id
end
