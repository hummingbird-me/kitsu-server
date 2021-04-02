class Types::Franchise < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description ''

  field :id, ID, null: false

  field :titles, Types::TitlesList,
    null: false,
    description: 'The name of this franchise in various languages'

  field :progession_order, Types::Enum::FranchiseProgressionOrder,
    null: false,
    description: ''

  field :installments, Types::Installment.connection_type, null: true do
    description ''
    argument :sort, Loaders::InstallmentsLoader.sort_argument, required: false
  end

  def installments(sort: [{ on: :release_position, direction: :desc }])
    Connections::FancyConnection.new(Loaders::InstallmentsLoader, {
      find_by: :franchise_id,
      sort: sort
    }, object.id)
  end
end
