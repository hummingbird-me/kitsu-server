class ActivityGroupResource < BaseResource
  include ScopelessResource

  model_name 'Feed::ActivityGroup'

  has_many :activities
end
