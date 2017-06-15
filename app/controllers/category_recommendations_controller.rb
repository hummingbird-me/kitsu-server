class CategoryRecommendationsController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate_user!
  before_action :validate_namespace

  def index
    serializer = CategoryRecommendationSerializer.new(
      CategoryRecommendationResource, include: %w[category media]
    )
    render_jsonapi serializer.serialize_to_hash(resources)
  end

  def realtime
    serializer = CategoryRecommendationSerializer.new(
      CategoryRecommendationResource, include: %w[category media]
    )
    render_jsonapi serializer.serialize_to_hash(realtime_resources)
  end

  private

  def resources
    recommendations.map do |item|
      CategoryRecommendationResource.new(item, context)
    end
  end

  def realtime_resources
    realtime_recommendations.map do |item|
      CategoryRecommendationResource.new(item, context)
    end
  end

  def recommendations_service
    RecommendationsService::Media.new(user)
  end

  def recommendations
    recommendations_service.category_recommendations_for(namespace_class)
  end

  def realtime_recommendations
    recommendations_service.realtime_category_recommendations_for(
      namespace_class
    )
  end

  def namespace
    @namespace ||= params[:namespace].classify
  end

  def namespace_class
    @namespace_class ||= namespace.safe_constantize
  end

  def validate_namespace
    unless %w[Anime Manga Drama].include?(namespace)
      render_jsonapi serialize_error(400, 'Invalid namespace'), status: 400
    end
  end
end
