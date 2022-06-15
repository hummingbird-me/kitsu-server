class CharacterVoice < ApplicationRecord
  belongs_to :media_character
  belongs_to :person
  belongs_to :licensor, class_name: 'Producer'

  validates :locale, presence: true

  def rails_admin_label
    "#{person.name} [#{locale}]"
  end
end
