class NotificationSettingStateResource < BaseResource
  attribute :is_toggled

  has_one :notification_setting
  has_one :user

  filters :user_id, :notification_setting_id
end
