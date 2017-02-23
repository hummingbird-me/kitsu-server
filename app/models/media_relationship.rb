# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_relationships
#
#  id               :integer          not null, primary key
#  destination_type :string           not null
#  role             :integer          not null
#  source_type      :string           not null, indexed => [source_id]
#  destination_id   :integer          not null
#  source_id        :integer          not null, indexed => [source_type]
#
# Indexes
#
#  index_media_relationships_on_source_type_and_source_id  (source_type,source_id)
#
# rubocop:enable Metrics/LineLength

class MediaRelationship < ApplicationRecord
  has_paper_trail
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
