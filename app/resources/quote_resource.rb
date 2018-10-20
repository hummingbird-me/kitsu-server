class QuoteResource < BaseResource
  attributes :content, :likes_count

  has_one :user
  has_one :media, polymorphic: true
  has_one :character

  filters :media_id, :media_type, :user_id, :character_id
end
