class Mutations::Comment < Mutations::Namespace
  field :create,
    mutation: Mutations::Comment::Create,
    description: 'Create a Comment.'

  field :edit,
    mutation: Mutations::Comment::Edit,
    description: 'Edit a Comment.'

  field :delete,
    mutation: Mutations::Comment::Delete,
    description: 'Delete a Comment.'

  field :like,
    mutation: Mutations::Comment::Like,
    description: 'Like a Comment.'
  
  field :unlike,
    mutation: Mutations::Comment::Unlike,
    description: 'Unlike a Comment.'
end
