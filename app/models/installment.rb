# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: installments
#
#  id           :integer          not null, primary key
#  media_type   :string           not null, indexed => [media_id]
#  position     :integer          default(0), not null
#  tag          :string
#  created_at   :datetime
#  updated_at   :datetime
#  franchise_id :integer          indexed
#  media_id     :integer          indexed => [media_type]
#
# Indexes
#
#  index_installments_on_franchise_id             (franchise_id)
#  index_installments_on_media_type_and_media_id  (media_type,media_id)
#
# rubocop:enable Metrics/LineLength

class Installment < ApplicationRecord
  include RankedModel
  ranks :release_order
  ranks :alternative_order

  enum tag: {
    main_story: 0,
    side_story: 1,
    spinoff: 2,
    crossover: 3,
    alternate_setting: 4
  }

  validates :media, polymorphism: { type: Media }

  belongs_to :franchise
  belongs_to :media, polymorphic: true
end
