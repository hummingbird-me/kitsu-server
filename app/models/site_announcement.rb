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

class SiteAnnouncement < ApplicationRecord
  include WithActivity
  include DescriptionSanitation

  belongs_to :user
  has_many :views, class_name: 'SiteAnnouncementView', dependent: :delete_all

  validates :title, presence: true

  def stream_activity
    SiteAnnouncementsGlobalFeed.new.activities.new
  end
end
