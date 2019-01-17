class Types::InputMediaCharacter < Types::InputChangeObject
  subject ::MediaCharacter

  argument :set_role, Types::CharacterRole, required: false
  argument :set_character, Types::InputCharacter, required: false

  def applied
    subject.role = set_role if set_role
    subject.character = set_character&.applied if set_character
    subject
  end
end
