class Mutations::WikiSubmission::SubmitDraft < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::WikiSubmission::SubmitDraft,
    required: true,
    description: 'Submit a wiki submission draft. This will change the status to pending.',
    as: :wiki_submission

  field :wiki_submission, Types::WikiSubmission, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_wiki_submission(value)
    wiki_submission = ::WikiSubmission.find(value.id)
    wiki_submission.assign_attributes(value.to_model)
    wiki_submission
  end

  def authorized?(wiki_submission:)
    super(wiki_submission, :submit_draft?)
  end

  def resolve(wiki_submission:)
    wiki_submission.save!

    { wiki_submission: wiki_submission }
  end
end
