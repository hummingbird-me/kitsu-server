class Types::Input::WikiSubmission::SubmitDraft < Types::Input::Base
  argument :id, ID, required: true
  argument :data, GraphQL::Types::JSON, required: true
  argument :title, String, required: false
  argument :notes, String, required: false

  def to_model
    to_h.merge(status: :pending)
  end
end
