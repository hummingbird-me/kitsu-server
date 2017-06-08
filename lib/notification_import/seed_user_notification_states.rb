module NotificationImport
  class SeedUserNotificationStates
    def initialize
      @init_settings = NotificationSetting.all
    end

    def create_user_notification_states!
      all_users_notif_states = []
      users = User.all

      users.each do |user|
        @init_settings.each do |ns|
          all_users_notif_states << { notification_setting: ns, user: user }
        end

        if all_users_notif_states.length == 2000
          NotificationSettingState.create(all_users_notif_states)
          all_users_notif_states.clear
        end
      end

      if all_users_notif_states.positive?
        NotificationSettingState.create(all_users_notif_states)
      end
    end

    def run!
      ActiveRecord::Base.logger = Logger.new(nil)
      Chewy.strategy(:bypass)
      create_user_notification_states!
    end
  end
end
