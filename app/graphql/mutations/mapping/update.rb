class Mutations::Mapping::Update < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Mapping::Update,
    required: true,
    description: 'Update a Mapping',
    as: :mapping

  field :mapping, Types::Mapping, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_mapping(value)
    mapping = ::Mapping.find(value.id)
    mapping.assign_attributes(value.to_model)
    mapping
  end

  def authorized?(mapping:)
    super(mapping, :update?)
  end

  def resolve(mapping:)
    mapping.save!

    { mapping: mapping }
  end
end
