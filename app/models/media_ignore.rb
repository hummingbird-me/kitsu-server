class MediaIgnore < ApplicationRecord
  belongs_to :media, polymorphic: true, optional: false
  belongs_to :user, optional: false

  validates :media, polymorphism: { type: Media }

  scope :for_library_entry, ->(le) { where(media: le.media, user: le.user) }

  def library_entry
    LibraryEntry.find_by(user: user, media: media)
  end

  def media_follow_service
    MediaFollowService.new(user, media)
  end

  after_commit(on: :create) { media_follow_service.destroy }
  after_commit(on: :destroy) { media_follow_service.create }
end
