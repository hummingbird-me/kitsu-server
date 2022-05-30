class DramaCasting < ApplicationRecord
  validates :locale, length: { maximum: 20 }
  validates :notes, length: { maximum: 140 }

  belongs_to :drama_character, optional: false
  belongs_to :person, optional: false
  belongs_to :licensor, class_name: 'Producer', optional: true
end
