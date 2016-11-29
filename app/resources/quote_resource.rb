class QuoteResource < BaseResource
  attributes :content, :positive_votes

  has_one :user
  has_one :anime
  has_one :character
end
