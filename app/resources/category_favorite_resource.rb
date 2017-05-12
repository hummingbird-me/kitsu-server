class CategoryFavoriteResource < BaseResource
  has_one :user
  has_one :category
end
