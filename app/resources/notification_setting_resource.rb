class NotificationSettingResource < BaseResource
  attributes :email_enabled, :fb_messenger_enabled,
    :mobile_enabled, :web_enabled, :setting_type

  has_one :user

  filters :id, :user_id
end
