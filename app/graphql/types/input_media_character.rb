class Types::InputMediaCharacter < Types::BaseInputObject
  argument :id, ID, required: false

  def subject
    @subject ||= MediaCharacter.where(id: id).first_or_initialize
  end

  argument :set_role, Types::CharacterRole, required: false
  argument :set_character, Types::InputCharacter, required: false

  def applied
    subject.role = set_role if set_role
    subject.character = set_character&.applied if set_character
    subject.tap(&:save!)
  end
end
