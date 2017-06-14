class CategoryRecommendation
  attr_accessor :category, :media, :id
  def initialize(params)
    @category = params[:category]
    @media = params[:media]
    @id = params[:id]
  end
end
