class UsersController < ApplicationController
  include CustomControllerHelpers

  http_basic_authenticate_with name: 'Production',
                               password: ENV['STAGING_SYNC_SECRET'],
                               only: :prod_sync
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
    UserMailer.password_reset(user).deliver_later
    render json: { username: query }
  end

  def prod_sync
    return unless Rails.env.staging?

    id = params.require(:id)
    values = params.permit(:password_digest, :email, :name, :pro_expires_at)

    User.find_by(id: id)&.update(values)

    render json: id, status: 200
  end

  def profile_strength
    user = current_user&.resource_owner
    user_id = params.require(:id).to_i
    unless user&.id == user_id
      return render_jsonapi serialize_error(401, 'Not permitted'), status: 401
    end

    # Get strength from Stream
    strength = RecommendationsService::Media.new(user).strength
    render json: strength, status: 200
  end

  def flags
    user = current_user&.resource_owner
    features = Flipper.preload_all
    flags = features.map { |f| [f.name, f.enabled?(user)] }.to_h
    enabled_flags = flags.select { |_, enabled| enabled }
    render json: enabled_flags, status: 200
  end
end
