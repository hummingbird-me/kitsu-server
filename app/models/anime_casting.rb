class AnimeCasting < ApplicationRecord
  validates :locale, length: { maximum: 20 }
  validates :notes, length: { maximum: 140 }

  belongs_to :anime_character, required: true
  belongs_to :person, required: true
  belongs_to :licensor, class_name: 'Producer', optional: true
end
