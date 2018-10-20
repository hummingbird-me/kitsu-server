class QuoteLikeResource < BaseResource
  has_one :quote
  has_one :user

  filters :quote_id, :user_id
end
