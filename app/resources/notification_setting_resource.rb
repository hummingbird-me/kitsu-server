class NotificationSettingResource < BaseResource
  attribute :setting_name

  has_many :notification_setting_states

  filter :id
end
