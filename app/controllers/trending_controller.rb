class TrendingController < ApplicationController
  def index
    serializer = JSONAPI::ResourceSerializer.new(resource_klass)
    json = serializer.serialize_to_hash(resources)
    render json: json
  end

  private

  def resources
    trending.map { |item| resource_class.new(item) }
  end

  def user
    doorkeeper_token.resource_owner
  end

  def trending_service
    TrendingService.new(namespace, user: user)
  end

  def trending
    if params[:in_network].present?
      trending_service.get_network(params[:limit])
    else
      trending_service.get(params[:limit])
    end
  end

  def namespace
    namespace = params[:namespace].classify
    raise 'Bad namespace' unless %w[Anime Manga Drama].include? namespace
    namespace.safe_constantize
  end

  def resource_class
    "#{namespace.class.name}Resource".safe_constantize
  end
end
