class Mutations::WikiSubmission::SubmitDraft < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::WikiSubmission::SubmitDraft,
    required: true,
    description: 'Submit a wiki submission draft.',
    as: :wiki_submission

  field :wiki_submission, Types::WikiSubmission, null: true
  field :errors, [Types::Interface::Error], null: true

  # NOTE: we might want to add a check, when data is supplied there should be NO id in the data.

  def load_wiki_submission(value)
    ::WikiSubmission.new(value.to_model)
  end

  def authorized?(wiki_submission:)
    super(wiki_submission, :submit_draft?)
  end

  def resolve(wiki_submission:)
    wiki_submission.save!

    { wiki_submission: wiki_submission }
  end
end
