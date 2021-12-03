class Installment < ApplicationRecord
  include RankedModel
  ranks :release_order
  ranks :alternative_order

  enum tag: {
    main_story: 0,
    side_story: 1,
    spinoff: 2,
    crossover: 3,
    alternate_setting: 4,
    alternate_version: 5
  }

  validates :media, polymorphism: { type: Media }

  belongs_to :franchise
  belongs_to :media, polymorphic: true
end
