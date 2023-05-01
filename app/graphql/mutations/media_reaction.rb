class Mutations::MediaReaction < Mutations::Namespace
  field :like, mutation: Mutations::MediaReaction::Like
  field :unlike, mutation: Mutations::MediaReaction::Unlike
end
