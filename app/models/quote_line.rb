class QuoteLine < ApplicationRecord
  include RankedModel
  ranks :order, with_same: %i[quote_id]

  belongs_to :quote, required: true
  belongs_to :character, required: true

  validates :content, presence: true
end
