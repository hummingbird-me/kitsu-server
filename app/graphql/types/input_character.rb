class Types::InputCharacter < Types::InputChangeObject
  subject ::Character
  localized_field :names

  def apply
    apply_names
    subject
  end
end
