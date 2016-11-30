class ReportResource < BaseResource
  attributes :reason, :status, :explanation

  has_one :naughty, polymorphic: true
  has_one :user
  has_one :moderator
end
