class ActivityGroupResource < BaseResource
  model_name 'Feed::ActivityGroup'

  has_many :activities
end
