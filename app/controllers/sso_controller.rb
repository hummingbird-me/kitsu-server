class SSOController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate!

  def canny
    token = CannyToken.new(current_user.resource_owner)
    render json: { token: token.to_s }
  end

  private

  def authenticate!
    unless signed_in?
      render 403, json: serialize_error(403, 'Not authenticated')
    end
  end
end
