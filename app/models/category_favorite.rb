class CategoryFavorite < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :category, optional: false

  validates :user_id, uniqueness: {
    scope: :category_id,
    message: 'Cannot fave a category multiple times'
  }
end
