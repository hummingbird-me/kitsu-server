class QuoteResource < BaseResource
  attributes :likes_count

  has_one :user
  has_one :media, polymorphic: true

  filters :media_id, :media_type, :user_id
end
