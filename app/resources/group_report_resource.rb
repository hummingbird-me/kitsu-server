class GroupReportResource < BaseResource
  include GroupActionLogger

  attributes :reason, :status, :explanation

  has_one :group
  has_one :naughty, polymorphic: true
  has_one :user
  has_one :moderator

  filters :group, :user, :naughty, :naughty_type, :status, :reason

  log_verb do
    status if action == :update
  end
  log_target []

  def self.sortable_fields(context)
    super(context) << :created_at
  end
end
