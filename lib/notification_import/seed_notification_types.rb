module NotificationImport
  class SeedNotificationTypes
    def initialize
      @init_types = %w[Mentions Replies Likes Follows Posts]
    end

    def create_notification_types!
      @init_types.each do |type|
        NotificationSetting.where(
          setting_name: type.titleize
        ).first_or_create
      end
    end

    def run!
      ActiveRecord::Base.logger = Logger.new(nil)
      Chewy.strategy(:bypass)
      create_notification_types!
    end
  end
end
