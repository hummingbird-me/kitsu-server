class Types::Input::WikiSubmission::SubmitDraft < Types::Input::Base
  argument :draft, GraphQL::Types::JSON, required: true

  def to_model
    to_h.merge(status: :draft)
  end
end
