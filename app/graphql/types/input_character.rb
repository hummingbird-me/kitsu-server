class Types::InputCharacter < Types::BaseInputObject
  argument :id, ID, required: false

  def subject
    @subject ||= Character.where(id: id).first_or_initialize
  end

  argument :add_names, Types::Map, required: false
  argument :remove_names, [String], required: false

  def apply_names
    subject.names.merge(add_titles) if add_names
    remove_names&.each { |k| subject.names.delete(k) }
  end

  def applied
    apply_names
    subject.tap(&:save!)
  end
end
