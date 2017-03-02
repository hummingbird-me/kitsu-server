class GroupBanResource < BaseResource
  include GroupActionLogger

  attributes :created_at

  has_one :group
  has_one :user
  has_one :moderator

  log_verb do |action|
    case action
    when :create then 'banned'
    when :remove then 'unbanned'
    end
  end
  log_target :user

  before_create do
    _model.moderator = actual_current_user
  end
end
