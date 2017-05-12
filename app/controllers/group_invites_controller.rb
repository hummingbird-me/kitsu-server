class GroupInvitesController < ApplicationController
  include CustomControllerHelpers

  before_action :authenticate!, only: %i[accept decline]
  before_action :acceptable?, only: %i[accept decline revoke]

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
    unless invite
      return render_jsonapi serialize_error(404, 'Not Found'), status: 404
    end
    user = current_user.resource_owner
    unless user == invite.user
      render_jsonapi serialize_error(403, 'Not Authorized'), status: 403
    end
  end

  def acceptable?
    if invite.unacceptable?
      render_jsonapi serialize_error(403, 'Already Responded'), status: 403
    end
  end

  def invite
    GroupInvite.find(params[:id])
  end
end
