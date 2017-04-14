class SiteAnnouncement < ApplicationRecord
  belongs_to :user, required: true

  validates :text, presence: true
end
