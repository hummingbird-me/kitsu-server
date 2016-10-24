class ActivityResource < BaseResource
  model_name 'Feed::Activity'

  attributes :status, :verb, :time, :stream_id, :foreign_id, :rating,
    :progress

  has_one :actor, class_name: 'User'
  has_one :unit, polymorphic: true
  has_one :media, polymorphic: true
  has_one :object, polymorphic: true
end
