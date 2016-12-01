class UsersController < ApplicationController
  http_basic_authenticate_with name: 'Production',
    password: ENV['STAGING_SYNC_SECRET'], only: :prod_sync
  skip_before_action :validate_token!, only: :prod_sync

  def recover
    query = params[:_json]
    user = User.find_for_auth(query)
    UserMailer.password_reset(user)
    render json: query
  end

  def prod_sync
    id = params.require(:id)
    values = params.permit(:password_digest, :email, :name, :pro_expires_at)

    User.find_by(id: id)&.update(values)

    render json: id, status: 200
  end
end
