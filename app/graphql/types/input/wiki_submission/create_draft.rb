class Types::Input::WikiSubmission::CreateDraft < Types::Input::Base
  argument :draft, GraphQL::Types::JSON, required: true
  argument :notes, String, required: false

  def to_model
    to_h.merge(status: :draft, user: current_user)
  end
end
