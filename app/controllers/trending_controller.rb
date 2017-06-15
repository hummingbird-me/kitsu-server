class TrendingController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate_for_in_network
  before_action :validate_namespace

  def index
    serializer = JSONAPI::ResourceSerializer.new(resource_class)
    render_jsonapi serializer.serialize_to_hash(resources)
  end

  private

  def resources
    trending.map { |item| resource_class.new(item, context) }
  end

  def user
    doorkeeper_token&.resource_owner
  end

  def trending_service
    TrendingService.new(namespace_class, token: doorkeeper_token)
  end

  def trending
    limit = params[:limit].present? ? params[:limit].to_i : 10
    if params[:in_network].present?
      trending_service.get_network(limit)
    elsif params[:in_category].present?
      trending_service.get_category(params[:category], limit)
    else
      trending_service.get(limit)
    end
  end

  def namespace
    @namespace ||= params[:namespace].classify
  end

  def namespace_class
    namespace.safe_constantize
  end

  def resource_class
    "#{namespace}Resource".safe_constantize
  end

  def authenticate_for_in_network
    if params[:in_network].present? && !user
      render_jsonapi serialize_error(403, 'Must be logged in for in_network'),
        status: 403
    end
  end

  def validate_namespace
    unless %w[Anime Manga Drama].include?(namespace)
      render_jsonapi serialize_error(400, 'Invalid namespace'), status: 400
    end
  end
end
