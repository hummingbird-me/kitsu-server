# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: site_announcements
#
#  id          :integer          not null, primary key
#  description :text
#  image_url   :string
#  link        :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Foreign Keys
#
#  fk_rails_725ca0b80c  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe SiteAnnouncement, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }
end
