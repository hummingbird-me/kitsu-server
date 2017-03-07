class GroupPermissionResource < BaseResource
  include GroupActionLogger

  attribute :permission

  has_one :group_member

  log_verb do |action|
    case action
    when :create then 'granted'
    when :remove then 'revoked'
    end
  end
  log_target :group_member, :user
  log_group :group_member, :group
end
