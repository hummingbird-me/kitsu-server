class Mutations::Mapping::Create < Mutations::Base
  argument :input,
    Types::Input::Mapping::Create,
    required: true,
    description: 'Create a Mapping',
    as: :mapping

  field :mapping, Types::Mapping, null: true

  def load_mapping(value)
    ::Mapping.new(value.to_model)
  end

  def authorized?(mapping:)
    super(mapping, :create?)
  end

  def resolve(mapping:)
    mapping.save

    if mapping.errors.any?
      Errors::RailsModel.graphql_error(mapping)
    else
      {
        mapping: mapping
      }
    end
  end
end
