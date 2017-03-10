class GroupInvitesController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate!, only: %i[accept decline]

  def accept
    invite.accept!
    render json: {}, status: 201
  end

  def decline
    invite.decline!
    render json: {}, status: 200
  end

  def revoke
    invite.revoke!
    render json: {}, status: 200
  end

  private

  def authenticate!
    serialize_error(404, 'Not Found') unless invite
    user = current_user.resource_owner
    serialize_error(403, 'Not Authorized') if user == invite.user
  end

  def invite
    GroupInvite.find(params[:id])
  end
end
