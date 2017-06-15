class CategoryRecommendationResource < BaseResource
  include ScopelessResource
  has_one :category
  has_many :media
end
