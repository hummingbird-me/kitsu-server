# frozen_string_literal: true

module Types::Interface::Unit
  include Types::Interface::Base

  description 'Media units such as episodes or chapters'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: false,
    description: 'The titles for this unit in various locales'

  def titles
    {
      localized: object.titles,
      canonical: object.canonical_title
    }
  end

  field :description,
    resolver: Resolvers::LocalizedField,
    description: 'A brief summary or description of the unit'

  field :number, Integer,
    null: false,
    description: 'The sequence number of this unit'

  image_field :thumbnail,
    description: 'A thumbnail image for the unit'
end
