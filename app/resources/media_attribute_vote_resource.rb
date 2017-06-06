class MediaAttributeVoteResource < BaseResource
  attribute :vote

  has_one :anime_media_attributes
  has_one :manga_media_attributes
  has_one :dramas_media_attributes
  has_one :user

  filters :created_at, :user_id, :anime_id,
    :drama_id, :manga_id
end
