class GroupTicketResource < BaseResource
  include GroupActionLogger

  attributes :title, :status, :created_at

  has_one :user
  has_one :group
  has_one :assignee
  has_many :messages

  filters :group, :user, :assignee
  filter :status, apply: ->(records, values, _options) {
    statuses = GroupTicket.statuses.values_at(*values).compact
    statuses = values if statuses.empty?
    records.where(status: statuses)
  }

  log_verb do |action|
    status if action == :update
  end
  log_target []
end
