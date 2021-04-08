class Mutations::WikiSubmission::ApproveDraft < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::WikiSubmission::ApproveDraft,
    required: true,
    description: 'Approve a wiki submission draft.',
    as: :wiki_submission

  field :wiki_submission, Types::WikiSubmission, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_wiki_submission(value)
    wiki_submission = ::WikiSubmission.find(value.draft['id'])
    wiki_submission.assign_attributes(value.to_model)
    wiki_submission
  end

  def authorized?(wiki_submission:)
    super(wiki_submission, :approve_draft?)
  end

  def resolve(wiki_submission:)
    wiki_submission.save!

    { wiki_submission: wiki_submission }
  end
end
