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
  belongs_to :media, required: true
  belongs_to :user, required: true

  validates :media, polymorphism: { type: Media }

  scope :for_library_entry, ->(le) { where(media: le.media, user: le.user) }

  # TODO: try and break this into a service which wraps this task.  We need to unfollow the media
  # feed and all episodes when this record is created, and then on deletion we create the episode
  # follows and media follow again.  We also need to enforce this stuff on LibraryEntry triggering
  # updates.
  # after_commit(on: :create) { user.interest_timeline_for(media_type).unfollow(media.feed) }
  # after_commit(on: :destroy) { user.interest_timeline_for(media_type).follow(media.feed) }
end
