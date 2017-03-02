class GroupReportResource < BaseResource
  include GroupActionLogger

  attributes :reason, :status, :explanation

  has_one :group
  has_one :naughty, polymorphic: true
  has_one :user
  has_one :moderator

  filters :user_id, :naughty_id, :naughty_type, :status, :reason

  log_verb do
    status if action == :update
  end
  log_target []
end
