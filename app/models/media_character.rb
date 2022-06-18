class MediaCharacter < ApplicationRecord
  enum role: %i[main supporting recurring cameo]

  belongs_to :media, polymorphic: true, inverse_of: :characters
  belongs_to :character, inverse_of: :media_characters
  has_many :voices, class_name: 'CharacterVoice', inverse_of: :media_character
  accepts_nested_attributes_for :voices, allow_destroy: true

  validates :role, presence: true

  def rails_admin_label
    character.canonical_name
  end
end
