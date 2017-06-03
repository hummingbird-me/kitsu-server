class MediaReactionResource < BaseResource
  attributes :reaction, :created_at, :up_votes_count

  has_one :media, polymorphic: true
  has_one :user
  has_one :library_entry
  has_many :votes

  filters :created_at, :up_votes_count, :media_type, :media_id, :user_id
end
