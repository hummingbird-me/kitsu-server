class ActivityResource < BaseResource
  model_name 'Feed::Activity'

  attributes :status, :verb, :time, :stream_id, :foreign_id

  has_one :actor, class_name: 'User'
  has_one :media, polymorphic: true
end
