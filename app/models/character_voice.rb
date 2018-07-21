class CharacterVoice < ApplicationRecord
  belongs_to :media_character, required: true
  belongs_to :person, required: true
  belongs_to :licensor, class_name: 'Producer'

  validates :locale, presence: true
end
