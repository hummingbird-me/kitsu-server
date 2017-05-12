class CategoryFavoriteResource < BaseResource
  has_one :user
  has_one :category
  filter :user_id
  filter :category_id
end
