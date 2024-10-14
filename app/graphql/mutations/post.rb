class Mutations::Post < Mutations::Namespace
  field :lock,
    mutation: Mutations::Post::Lock,
    description: 'Lock a Post.'

  field :unlock,
    mutation: Mutations::Post::Unlock,
    description: 'Unlock a Post.'

  field :create,
    mutation: Mutations::Post::Create,
    description: 'Create a Post.'

  field :edit,
    mutation: Mutations::Post::Edit,
    description: 'Edit a Post.'

  field :delete,
    mutation: Mutations::Post::Delete,
    description: 'Delete a Post.'
  
  field :follow,
    mutation: Mutations::Post::Follow,
    description: 'Follow a Post.'
  
  field :unfollow,
    mutation: Mutations::Post::Unfollow,
    description: 'Unfollow a Post.'

  field :like,
    mutation: Mutations::Post::Like,
    description: 'Like a Post.'
  
  field :unlike,
    mutation: Mutations::Post::Unlike,
    description: 'Unlike a Post.'
end
