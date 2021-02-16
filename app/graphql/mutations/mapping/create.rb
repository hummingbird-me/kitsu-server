class Mutations::Mapping::Create < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Mapping::Create,
    required: true,
    description: 'Create a Mapping',
    as: :mapping

  field :mapping, Types::Mapping, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_mapping(value)
    ::Mapping.new(value.to_model)
  end

  def authorized?(mapping:)
    super(mapping, :create?)
  end

  def resolve(mapping:)
    mapping.save!

    { mapping: mapping }
  end
end
