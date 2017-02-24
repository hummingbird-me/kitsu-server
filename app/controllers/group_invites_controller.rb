class GroupInvitesController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate!, only: %i[accept decline]

  def accept
    invite.accept!
  end

  def decline
    invite.decline!
  end

  private

  def authenticate!
    serialize_error(404, 'Not Found') unless invite
    user = current_user.resource_owner
    serialize_error(403, 'Not Authorized') if user == invite.user
  end

  def invite
    GroupInvite.find(params[:group_invite_id])
  end
end
