class ReviewResource < BaseResource
  attributes :content, :content_formatted, :summary, :legacy,
    :likes_count, :progress, :rating, :source

  has_one :library_entry
  has_one :media, polymorphic: true
  has_one :user
end
