class MangaMediaAttributeResource < BaseResource
  attributes :high_vote_count, :low_vote_count, :neutral_vote_count

  has_one :anime
  has_one :media_attribute
  has_many :media_attribute_votes

  filter :anime_id
end
