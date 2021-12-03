class CategoryFavorite < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :category, required: true

  validates :user_id, uniqueness: {
    scope: :category_id,
    message: 'Cannot fave a category multiple times'
  }
end
