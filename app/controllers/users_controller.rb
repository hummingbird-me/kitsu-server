class UsersController < ApplicationController
  include Pundit

  http_basic_authenticate_with name: 'Production',
    password: ENV['STAGING_SYNC_SECRET'], only: :prod_sync
  skip_before_action :validate_token!, only: :prod_sync
  skip_after_action :enforce_policy_use, only: %i[prod_sync recover]

  def recover
    query = params[:username]
    unless query.present?
      render json: { errors: [{ title: 'Username missing', status: '400' }] }, status: 400
      return
    end
    user = User.find_for_auth(query)
    unless user.present?
      render json: { errors: [{ title: 'User not found', status: '400' }] }, status: 400
      return
    end
    UserMailer.password_reset(user)
    render json: { username: query }
  end

  def prod_sync
    id = params.require(:id)
    values = params.permit(:password_digest, :email, :name, :pro_expires_at)

    User.find_by(id: id)&.update(values)

    render json: id, status: 200
  end
end
