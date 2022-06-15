class MediaRelationship < ApplicationRecord
  enum role: {
    sequel: 0,
    prequel: 1,
    alternative_setting: 2,
    alternative_version: 3,
    side_story: 4,
    parent_story: 5,
    summary: 6,
    full_story: 7,
    spinoff: 8,
    adaptation: 9,
    character: 10,
    other: 11
  }

  belongs_to :source, polymorphic: true, inverse_of: :media_relationships
  belongs_to :destination, polymorphic: true, inverse_of: :inverse_media_relationships

  validates :source, polymorphism: { type: Media }
  validates :destination, polymorphism: { type: Media }

  def rails_admin_label
    "#{source.canonical_title} -(#{role})-> #{destination.canonical_title}"
  end
end
