class QuoteResource < BaseResource
  attributes :anime_id, :character_id, :content, :user_id, :positive_votes

  has_one :user
  has_one :anime
  has_one :character
end
