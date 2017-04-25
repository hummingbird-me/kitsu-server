# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: user_settings
#
#  id         :integer          not null, primary key
#  type       :string           not null
#  value      :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null, indexed
#
# Indexes
#
#  index_user_settings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_d1371c6356  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class UserSetting < ApplicationRecord
  belongs_to :user, required: true, touch: true

  def self.create_defaults_for(user)
    # Run .create_default_for(user) on each subclass
    UserSetting.descendants.map { |setting| setting.create_default_for(user) }
  end
end

# Load subclasses
Dir['app/models/user_setting/*.rb'].each do |file|
  require_dependency(File.expand_path(file))
end
