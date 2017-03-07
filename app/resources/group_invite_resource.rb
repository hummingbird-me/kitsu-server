class GroupInviteResource < BaseResource
  include GroupActionLogger

  attributes :accepted_at, :declined_at

  has_one :user
  has_one :group
  has_one :sender

  filters :group, :sender, :user

  log_verb do |action|
    case action
    when :create then 'invited'
    end
  end
  log_target :user

  before_create do
    _model.sender = actual_current_user
  end
end
