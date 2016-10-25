class FollowsController < ApplicationController
  def import_from_facebook
    Authorization::Assertion::Facebook.new(params[:assertion]).import_friends
  end
end
