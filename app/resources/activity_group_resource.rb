class ActivityGroupResource < BaseResource
  include ScopelessResource

  model_name 'Feed::ActivityGroup'

  # notifications
  attributes :group, :is_seen, :is_read

  has_many :activities
end
