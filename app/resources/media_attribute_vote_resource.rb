class MediaAttributeVoteResource < BaseResource
  attribute :vote

  has_one :anime
  has_one :drama
  has_one :manga
  has_one :user

  filters :created_at, :user_id, :anime_id,
    :drama_id, :manga_id
end
