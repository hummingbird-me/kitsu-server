class Mutations::ApplyChangeset < Mutations::BaseMutation
  null false

  argument :id, ID, required: true

  payload_type Types::Changeset

  def authorized?(*)
    return true if context[:current_user]&.has_role?(:db_mod)

    raise GraphQL::ExecutionError, 'You are not authorized to edit the Kitsu database'
  end

  def resolve(id:)
    ::Changeset.find(id).tap do |changeset|
      changeset.apply.save!
      changeset.update(status: :accepted)
    end
  end
end
