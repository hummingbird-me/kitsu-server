class Mutations::WikiSubmission::CreateDraft < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::WikiSubmission::CreateDraft,
    required: true,
    description: 'Create a wiki submission draft.',
    as: :wiki_submission

  field :wiki_submission, Types::WikiSubmission, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_wiki_submission(value)
    ::WikiSubmission.new(value.to_model)
  end

  def authorized?(wiki_submission:)
    super(wiki_submission, :create_draft?)
  end

  def resolve(wiki_submission:)
    wiki_submission.save!

    { wiki_submission: wiki_submission }
  end
end
