class FollowsController < ApplicationController
  def import_from_facebook
    Authorization::Assertion::Facebook.new(params[:assertion]).import_friends
  end

  def import_from_twitter
    Authorization::Assertion::Twitter.new(
      params[:access_token],
      params[:access_token_secret]
    ).import_friends
  end
end
