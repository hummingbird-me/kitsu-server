class GroupReportResource < BaseResource
  include GroupActionLogger

  attributes :reason, :status, :explanation, :naughty_type, :naughty_id

  has_one :group
  has_one :naughty, polymorphic: true
  has_one :user
  has_one :moderator

  filters :group, :user, :naughty, :naughty_type, :reason
  filter :status, verify: ->(values, _) {
    values.map { |v| GroupReport.statuses[v] || v }
  }

  log_verb do |action|
    status if action == :update
  end
  log_target []
end
