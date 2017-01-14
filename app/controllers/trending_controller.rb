class TrendingController < ApplicationController
  skip_after_action :enforce_policy_use

  def index
    serializer = JSONAPI::ResourceSerializer.new(resource_class)
    json = serializer.serialize_to_hash(resources)
    render json: json
  end

  private

  def resources
    trending.map { |item| resource_class.new(item, context) }
  end

  def user
    doorkeeper_token&.resource_owner
  end

  def trending_service
    TrendingService.new(namespace_class, user: user)
  end

  def trending
    if params[:in_network].present?
      raise 'Must be logged in' unless user
      trending_service.get_network(params[:limit] || 10)
    else
      trending_service.get(params[:limit] || 10)
    end
  end

  def namespace
    return @namespace if @namespace
    namespace = params[:namespace].classify
    raise 'Bad namespace' unless %w[Anime Manga Drama].include? namespace
    @namespace = namespace
  end

  def namespace_class
    namespace.safe_constantize
  end

  def resource_class
    "#{namespace}Resource".safe_constantize
  end
end
