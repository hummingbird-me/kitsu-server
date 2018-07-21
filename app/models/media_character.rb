class MediaCharacter < ApplicationRecord
  enum role: %i[main supporting]

  belongs_to :media, polymorphic: true, required: true
  belongs_to :character, required: true
  has_many :voices, class_name: 'CharacterVoice'
end
