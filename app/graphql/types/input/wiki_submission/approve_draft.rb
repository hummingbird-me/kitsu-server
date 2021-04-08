class Types::Input::WikiSubmission::ApproveDraft < Types::Input::Base
  argument :draft, GraphQL::Types::JSON, required: true

  def to_model
    to_h.merge(status: :approved)
  end
end
