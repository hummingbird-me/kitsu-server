class FollowsController < ApplicationController
  skip_after_action :enforce_policy_use, only: %i[import_from_facebook
                                                  import_from_twitter]

  def import_from_facebook
    facebook = Authorization::Assertion::Facebook.new(params[:assertion])
    render json: serialize_follows(facebook.import_friends)
  end

  def import_from_twitter
    twitter = Authorization::Assertion::TwitterAuth.new(
      params[:access_token],
      params[:access_token_secret]
    )
    render json: serialize_follows(twitter.import_friends)
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
