class CharacterVoice < ApplicationRecord
  belongs_to :media_character, optional: false
  belongs_to :person, optional: false
  belongs_to :licensor, class_name: 'Producer'

  validates :locale, presence: true
end
