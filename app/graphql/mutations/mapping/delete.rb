class Mutations::Mapping::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Delete a Mapping',
    as: :mapping

  field :mapping, Types::GenericDelete, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_mapping(value)
    ::Mapping.find(value.id)
  end

  def authorized?(mapping:)
    super(mapping, :destroy?)
  end

  def resolve(mapping:)
    mapping.destroy!

    { mapping: { id: mapping.id } }
  end
end
