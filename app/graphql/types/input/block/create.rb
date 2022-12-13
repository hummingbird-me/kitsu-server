class Types::Input::Block::Create < Types::Input::Base
    argument :blocked_id, ID, required: true
  
    def to_model
      to_h.merge({ user_id: current_user&.id })
    end
  end