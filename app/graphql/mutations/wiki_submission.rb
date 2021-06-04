class Mutations::WikiSubmission < Mutations::Namespace
  field :create_draft,
    mutation: Mutations::WikiSubmission::CreateDraft,
    description: 'Create a wiki submission draft'

  field :update_draft,
    mutation: Mutations::WikiSubmission::UpdateDraft,
    description: 'Update a wiki submission draft'

  field :submit_draft,
    mutation: Mutations::WikiSubmission::SubmitDraft,
    description: 'Submit a wiki submission draft'
end
