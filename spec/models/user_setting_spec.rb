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

require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  it { should belong_to(:user) }
end
