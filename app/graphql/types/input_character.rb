class Types::InputCharacter < Types::InputChangeObject
  subject ::Character
  localized_field :names

  def applied
    apply_names
    subject.tap(&:save!)
  end
end
