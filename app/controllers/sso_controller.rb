class SSOController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate!

  def canny
    token = CannyToken.new(current_user.resource_owner)
    render json: { token: token.to_s }
  end

  private

  def authenticate!
    render status: 403, json: serialize_error(403, 'Not authenticated') unless signed_in?
  end
end
