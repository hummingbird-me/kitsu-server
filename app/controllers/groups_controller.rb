class GroupsController < ApplicationController
  include CustomControllerHelpers

  def stats
    stats = { today: {}, total: {} }

    if has_group_permission?(:members)
      stats[:today][:members] = GroupMember.in_group(group).created_today.count
      stats[:total][:members] = GroupMember.in_group(group).count
    end
    if has_group_permission?(:content)
      stats[:today][:posts] = Post.in_group(group).created_today.count
      stats[:today][:comments] = Comment.in_group(group).created_today.count
      stats[:total][:openReports] = GroupReport.in_group(group).reported.count
    end
    if has_group_permission?(:tickets)
      stats[:total][:openTickets] = GroupTicket.in_group(group).created.count
    end

    render json: stats
  end

  def read
    member&.mark_read!
    render json: {}, status: 200
  end

  def group
    @group ||= Group.find(params[:id])
  end

  def member
    @member ||= group.member_for(user)
  end

  def user
    @user ||= doorkeeper_token&.resource_owner
  end

  def has_group_permission?(permission)
    member && member.has_permission?(permission)
  end
end
