class CharacterVoice < ApplicationRecord
  belongs_to :media_character, inverse_of: :voices
  belongs_to :person, inverse_of: :voices
  belongs_to :licensor, class_name: 'Producer', optional: true

  validates :locale, presence: true

  def rails_admin_label
    "#{person.name} [#{locale}]"
  end
end
