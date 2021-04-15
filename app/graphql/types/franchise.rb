class Types::Franchise < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Related media grouped together'

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: false,
    description: 'The name of this franchise in various languages'

  def titles
    {
      localized: object.titles,
      alternatives: object.abbreviated_titles.presence || [],
      canonical: object.canonical_title,
      canonical_locale: object.canonical_title_key
    }
  end

  field :installments, Types::Installment.connection_type, null: true do
    description 'All media related to a franchise'
    argument :sort, Loaders::InstallmentsLoader.sort_argument, required: false
  end

  def installments(sort: [{ on: :release_order, direction: :asc }])
    Loaders::InstallmentsLoader.connection_for({
      find_by: :franchise_id,
      sort: sort
    }, object.id)
  end
end
