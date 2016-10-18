class FollowersController < ApplicationController
  def facebook
    Authorization::Assertion::Facebook.new(params[:assertion]).friends
  end
end
