class OneSignalPlayerResource < BaseResource
  attributes :player_id, :platform

  has_one :user

  filter :player_id
end
