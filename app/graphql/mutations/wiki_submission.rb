class Mutations::WikiSubmission < Mutations::Namespace
  field :create_draft,
    mutation: Mutations::WikiSubmission::CreateDraft,
    description: 'Create a wiki submission draft'
end
