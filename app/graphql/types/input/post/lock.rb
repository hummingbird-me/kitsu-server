class Types::Input::Post::Lock < Types::Input::Base
  argument :id, ID, required: true
  argument :lock_reason, Types::Enum::LockReason, required: true

  def to_model
    to_h.merge(locked_at: DateTime.current, locked_by: current_user)
  end
end
