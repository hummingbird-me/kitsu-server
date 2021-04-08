class Types::Input::WikiSubmission::CreateDraft < Types::Input::Base
  argument :draft, GraphQL::Types::JSON, required: true

  def to_model
    to_h.merge(status: :draft)
  end
end
