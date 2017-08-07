# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: one_signal_players
#
#  id         :integer          not null, primary key
#  platform   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :string
#  user_id    :integer          indexed
#
# Indexes
#
#  index_one_signal_players_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_9384bbcdb2  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class OneSignalPlayer < ApplicationRecord
  belongs_to :user

  enum platform: %i[web mobile]

  def self.filter_player_ids(player_ids, notif_type)
    player_objects = OneSignalPlayer.includes(
      user: :notification_settings
    ).where(
      id: player_ids
    )

    player_objects.each_with_object([]) do |player, acc|
      user_setting = player.user.notification_settings.select { |setting|
        setting.setting_type == notif_type
      }.first
      acc << if player.web? && user_setting&.web_enabled
               player.id
             elsif player.mobile? && user_setting&.mobile_enabled
               player.id
             end
    end
  end
end
