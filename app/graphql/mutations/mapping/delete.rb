class Mutations::Mapping::Delete < Mutations::Base
  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete a Mapping',
    as: :mapping

  field :mapping, Types::GenericDelete, null: true

  def load_mapping(value)
    ::Mapping.find(value.id)
  end

  def authorized?(mapping:)
    super(mapping, :destroy?)
  end

  def resolve(mapping:)
    mapping.destroy

    if mapping.errors.any?
      Errors::RailsModel.graphql_error(mapping)
    else
      {
        mapping: { id: mapping.id }
      }
    end
  end
end
