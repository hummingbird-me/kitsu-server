class Mutations::ProfileLink < Mutations::Namespace
	field :create,
		mutation: Mutations::ProfileLink::Create,
		description: 'Add a profile link.'
	field :update,
		mutation: Mutations::ProfileLink::Update,
		description: 'Update a profile link.'
	field :delete,
		mutation: Mutations::ProfileLink::Delete,
		description: 'Delete a profile link.'
end