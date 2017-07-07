class MediaReactionResource < BaseResource
  attributes :reaction, :up_votes_count

  has_one :anime
  has_one :drama
  has_one :manga
  has_one :user
  has_one :library_entry
  has_many :votes

  filters :created_at, :up_votes_count,
    :user_id, :anime_id, :drama_id, :manga_id, :media_type
end
