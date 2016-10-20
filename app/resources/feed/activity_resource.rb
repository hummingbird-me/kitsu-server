class Feed::ActivityResource < BaseResource
  attributes :status, :verb, :time, :stream_id, :foreign_id

  has_one :actor, class_name: 'User'
  has_one :media, polymorphic: true
end
