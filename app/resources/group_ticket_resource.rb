class GroupTicketResource < BaseResource
  include GroupActionLogger

  attributes :title, :status, :created_at

  has_one :user
  has_one :group
  has_one :assignee
  has_many :messages

  filters :group, :user, :assignee, :status

  log_verb do |action|
    status if action == :update
  end
  log_target []
end
