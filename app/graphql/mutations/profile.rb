class Mutations::Profile < Mutations::Namespace
    field :update,
      mutation: Mutations::Profile::Update,
      description: 'Update the profile of the current user.'
  end
  