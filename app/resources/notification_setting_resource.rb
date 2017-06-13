class NotificationSettingResource < BaseResource
  attributes :is_email_toggled, :is_fb_messenger_toggled,
    :is_mobile_toggled, :setting_type

  has_one :user

  filters :id, :user_id
end
