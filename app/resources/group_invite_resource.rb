class GroupInviteResource < BaseResource
  include GroupActionLogger

  attributes :accepted_at, :declined_at, :revoked_at

  has_one :user
  has_one :group
  has_one :sender

  filters :group, :sender, :user
  filter :status, apply: ->(records, values, _o) {
    records.by_status(values.first)
  }

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
