class MediaCharacter < ApplicationRecord
  enum role: %i[main supporting recurring cameo]

  belongs_to :media, polymorphic: true, required: true, inverse_of: :characters
  belongs_to :character, required: true
  has_many :voices, class_name: 'CharacterVoice'
end
