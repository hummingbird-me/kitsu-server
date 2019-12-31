class FollowsController < ApplicationController
  def import_from_facebook
    facebook = Authorization::Assertion::Facebook.new(params[:assertion])
    render json: serialize_follows(facebook.auto_follows)
  end

  def serialize_follows(follows)
    serializer.serialize_to_hash(wrap_in_resources(follows))
  end

  def wrap_in_resources(follows)
    follows.map { |follow| FollowResource.new(follow, context) }
  end

  def serializer
    JSONAPI::ResourceSerializer.new(FollowResource, include: %w[followed])
  end
end
