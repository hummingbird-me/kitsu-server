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

  # With the flag on, the filters below answer these from the database instead of Elasticsearch
  def self.searchable?
    super && !Flipper[:sql_group_ticket_search].enabled?(User.current)
  end

  filter :query_group, apply: ->(records, values, _options) { records.where(group_id: values) }
  # Matches the name of whoever opened or was assigned the ticket, or a message the searcher can see
  filter :query, apply: ->(records, values, options) {
    text = "%#{GroupTicket.sanitize_sql_like(values.join(' '))}%"
    people = User.where('users.name ILIKE ?', text).select(:id)
    messages = GroupTicketMessage.visible_for(options[:context][:current_user]&.resource_owner)
                                 .where('group_ticket_messages.content ILIKE ?', text)
    records = records.where(user_id: people).or(records.where(assignee_id: people))
                     .or(records.where(id: messages.select(:ticket_id)))
    # Nobody asked for an order, so show the newest tickets first
    options[:sort_criteria].present? ? records : records.order(created_at: :desc)
  }

  log_verb do |action|
    status if action == :update && previous_changes.include?('status')
  end
  log_target []
end
