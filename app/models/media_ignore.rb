# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_ignores
#
#  id         :integer          not null, primary key
#  media_type :string           indexed => [media_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  media_id   :integer          indexed => [media_type]
#  user_id    :integer          indexed
#
# Indexes
#
#  index_media_ignores_on_media_type_and_media_id  (media_type,media_id)
#  index_media_ignores_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_ce29fae9fe  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class MediaIgnore < ApplicationRecord
  belongs_to :media, polymorphic: true, required: true
  belongs_to :user, required: true

  validates :media, polymorphism: { type: Media }

  scope :for_library_entry, ->(le) { where(media: le.media, user: le.user) }

  def library_entry
    LibraryEntry.find_by(user: user, media: media)
  end

  def media_follow_service
    MediaFollowService.new(user, media)
  end

  after_commit(on: :create) { media_follow_service.destroy(library_entry&.progress) }
  after_commit(on: :destroy) { media_follow_service.create(library_entry&.progress) }
end
