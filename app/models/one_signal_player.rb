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
  
  validates :player_id, uniqueness: true, presence: true

  scope :enabled_for_setting, ->(setting) do
    where(platform: platforms & setting.enabled_platforms)
  end
end
