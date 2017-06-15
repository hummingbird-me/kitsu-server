class CategoryRecommendation
  attr_accessor :category, :media, :id
  def initialize(category:, media:, id:)
    @category = category
    @media = media
    @id = id
  end
end
