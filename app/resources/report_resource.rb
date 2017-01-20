class ReportResource < BaseResource
  attributes :reason, :status, :explanation

  has_one :naughty, polymorphic: true
  has_one :user
  has_one :moderator

  filters :user_id, :naughty_id, :naughty_type, :status, :reason
end
