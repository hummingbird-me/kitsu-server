class ActivityResource < BaseResource
  include ScopelessResource

  model_name 'Feed::Activity'

  attributes :status, :verb, :time, :stream_id, :foreign_id, :rating,
    :progress, :reply_to_type, :reply_to_user, :nineteen_scale, :mentioned_users

  has_one :actor, class_name: 'User', eager_load_on_include: false
  has_one :unit, polymorphic: true, eager_load_on_include: false
  has_one :media, polymorphic: true, eager_load_on_include: false
  has_one :subject, polymorphic: true, eager_load_on_include: false
  has_one :target, polymorphic: true, eager_load_on_include: false
end
