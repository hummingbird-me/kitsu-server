class CategoryResource < BaseResource
  attributes :title, :description
  attribute :image, format: :attachment

  has_one :parent
  has_many :anime
  has_many :drama
  has_many :manga
end
