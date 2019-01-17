class Types::InputAnime < Types::InputChangeObject
  subject ::Anime

  localized_field :titles
  argument :set_canonical_title, String, required: false

  has_many :characters, Types::InputMediaCharacter

  def applied
    apply_titles
    subject.canonical_title = set_canonical_title if set_canonical_title
    apply_characters

    subject
  end
end
