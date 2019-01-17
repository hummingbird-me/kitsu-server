class Types::InputAnime < Types::BaseInputObject
  argument :add_titles, Types::Map, required: false
  argument :remove_titles, [String], required: false

  def apply_titles_to(anime)
    anime.titles.merge(add_titles) if add_titles
    remove_titles&.each { |k| anime.titles.delete(k) }
  end

  def apply_to(anime)
    apply_titles_to(anime)
  end
end
