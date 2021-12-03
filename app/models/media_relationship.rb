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

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  validates :source, polymorphism: { type: Media }
  validates :destination, polymorphism: { type: Media }
end
