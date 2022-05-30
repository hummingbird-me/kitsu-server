class MediaCharacter < ApplicationRecord
  enum role: { main: 0, supporting: 1, recurring: 2, cameo: 3 }

  belongs_to :media, polymorphic: true, optional: false, inverse_of: :characters
  belongs_to :character, optional: false
  has_many :voices, class_name: 'CharacterVoice'
end
