class OneSignalPlayer < ApplicationRecord
  belongs_to :user

  enum platform: %i[web mobile]
  
  validates :player_id, uniqueness: true, presence: true

  scope :enabled_for_setting, ->(setting) do
    where(platform: platforms & setting.enabled_platforms)
  end
end
