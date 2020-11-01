class Types::Input::Post::Unlock < Types::Input::Base
  argument :id, ID, required: true

  def to_model
    to_h.merge(locked_at: nil, locked_by: nil, locked_reason: nil)
  end
end
