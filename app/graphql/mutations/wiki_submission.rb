class Mutations::WikiSubmission < Mutations::Namespace
  field :submit_draft,
    mutation: Mutations::WikiSubmission::SubmitDraft,
    description: 'Submit a wiki submission draft'

  field :approve_draft,
    mutation: Mutations::WikiSubmission::ApproveDraft,
    description: 'Approve a wiki submission draft'
end
