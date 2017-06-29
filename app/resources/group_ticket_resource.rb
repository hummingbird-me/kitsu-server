class GroupTicketResource < BaseResource
  include GroupActionLogger

  attribute :status

  has_one :user
  has_one :group
  has_one :assignee
  has_many :messages
  has_one :first_message

  filters :group, :user, :assignee
  filter :status, apply: ->(records, values, _options) {
    statuses = GroupTicket.statuses.values_at(*values).compact
    statuses = values if statuses.empty?
    records.where(status: statuses)
  }

  index GroupTicketsIndex::GroupTicket

  query :query_group, apply: ->(values, _ctx) {
    { term: { group_id: values.join(' ') } }
  }
  query :query,
    mode: :query,
    apply: ->(values, _ctx) {
      {
        multi_match: {
          fields: %w[user assignee status messages],
          query: values.join(' ')
        }
      }
    }

  log_verb do |action|
    status if action == :update && previous_changes.include?('status')
  end
  log_target []
end
