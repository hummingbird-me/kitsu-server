class UsersController < ApplicationController
  def recover
    query = params[:_json]
    user = User.find_for_auth(query)
    UserMailer.password_reset(user)
    render json: query
  end
end
