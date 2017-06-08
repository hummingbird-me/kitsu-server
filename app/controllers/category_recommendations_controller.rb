class CategoryRecommendationsController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate_user
  before_action :validate_namespace

  def index
    render_jsonapi recommendations
  end

  def realtime
    render_jsonapi realtime_recommendations
  end

  private

  def user
    doorkeeper_token&.resource_owner
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

  def resource_class
    "#{namespace}Resource".safe_constantize
  end

  def authenticate_user
    unless user
      render_jsonapi serialize_error(403, 'Must be logged in'), status: 403
    end
  end

  def validate_namespace
    unless %w[Anime Manga Drama].include?(namespace)
      render_jsonapi serialize_error(400, 'Invalid namespace'), status: 400
    end
  end
end
