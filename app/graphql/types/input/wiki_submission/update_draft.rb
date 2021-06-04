class Types::Input::WikiSubmission::UpdateDraft < Types::Input::Base
  argument :id, ID, required: true
  argument :draft, GraphQL::Types::JSON, required: true
  argument :notes, String, required: false

  def to_model
    to_h.merge(status: :draft)
  end
end
