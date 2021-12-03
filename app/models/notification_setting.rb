class NotificationSetting < ApplicationRecord
  NOTIFICATION_TYPES = %i[mentions replies likes follows posts reaction_votes airing].freeze
  DEFAULT_SETTINGS = {
    #                FB,   Mobile, Email, Web
    mentions:       [false, true,  false, true],
    replies:        [false, true,  false, true],
    likes:          [false, false, false, false],
    follows:        [false, true,  false, true],
    posts:          [false, true,  false, true],
    reaction_votes: [false, false, false, false],
    airing:         [false, true,  true,  true]
  }.freeze

  enum setting_type: NOTIFICATION_TYPES
  belongs_to :user, required: true

  def enabled_platforms
    %i[email fb_messenger mobile web].select do |platform|
      send("#{platform}_enabled?")
    end
  end

  def self.setup!(user)
    # Get the list of existing settings
    existing_settings = setting_types.values_at(*where(user: user).pluck(:setting_type))
    # Figure out which ones to create
    settings_to_create = (NOTIFICATION_TYPES - existing_settings)
    # Build a list of values to insert
    settings = DEFAULT_SETTINGS.select { |k, _| settings_to_create.include?(k) }
                               .map { |key, values| [user.id, setting_types[key], *values] }
    # Import 'em
    NotificationSetting.import(%i[
      user_id setting_type fb_messenger_enabled mobile_enabled email_enabled web_enabled
    ], settings)
  end
end
