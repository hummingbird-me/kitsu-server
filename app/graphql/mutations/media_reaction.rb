# frozen_string_literal: true

class Mutations::MediaReaction < Mutations::Namespace
  field :like, mutation: Mutations::MediaReaction::Like
  field :unlike, mutation: Mutations::MediaReaction::Unlike
  field :create, mutation: Mutations::MediaReaction::Create
end
