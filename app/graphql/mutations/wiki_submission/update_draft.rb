class Mutations::WikiSubmission::UpdateDraft < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::WikiSubmission::UpdateDraft,
    required: true,
    description: 'Update a wiki submission draft.',
    as: :wiki_submission

  field :wiki_submission, Types::WikiSubmission, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_wiki_submission(value)
    wiki_submission = ::WikiSubmission.find(value.id)
    wiki_submission.assign_attributes(value.to_model)
    wiki_submission
  end

  def authorized?(wiki_submission:)
    # Add a check to make sure the status is not approved. We might want a different mutation for rejected.
    # if so, we should only allow draft/pending to be updated.
    return true
    super(wiki_submission, :update_draft?)
  end

  def resolve(wiki_submission:)
    wiki_submission.save!

    { wiki_submission: wiki_submission }
  end
end
