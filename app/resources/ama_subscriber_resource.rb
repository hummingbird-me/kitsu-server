class AMASubscriberResource < BaseResource
  has_one :user
  has_one :ama

  filter :ama_id
end
