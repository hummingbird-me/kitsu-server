class QuoteLine < ApplicationRecord
  include RankedModel
  ranks :order, with_same: %i[quote_id]

  belongs_to :quote, optional: false
  belongs_to :character, optional: false

  validates :content, presence: true
end
