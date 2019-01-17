class Types::InputAnime < Types::BaseInputObject
  argument :id, ID, required: false

  def subject
    @subject ||= Anime.where(id: id).first_or_initialize
  end

  argument :add_titles, Types::Map, required: false
  argument :remove_titles, [String], required: false

  def apply_titles
    subject.titles.merge(add_titles) if add_titles
    remove_titles&.each { |k| subject.titles.delete(k) }
  end

  argument :add_characters, [Types::InputMediaCharacter], required: false
  argument :remove_characters, [ID], required: false

  def apply_characters
    subject.characters << add_characters.map(&:applied) if add_characters
    subject.characters.delete(*remove_characters)
  end

  def applied
    apply_titles
    apply_characters
    subject.tap(&:save!)
  end
end
