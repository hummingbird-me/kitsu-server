class GroupTicketResource < BaseResource
  include GroupActionLogger

  attributes :status, :created_at

  has_one :user
  has_one :group
  has_one :assignee
  has_many :messages

  log_verb do |action|
    status if action == :update
  end
  log_target []
end
