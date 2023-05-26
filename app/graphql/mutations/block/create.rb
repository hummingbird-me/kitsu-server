# frozen_string_literal: true

class Mutations::Block::Create < Mutations::Base
  include FancyMutation

  description 'Block a user'

  input do
    argument :blocked_id, ID,
      required: true,
      description: 'The id of the user to block.'
  end
  result Types::Block
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound

  def ready?(**)
    authenticate!
    true
  end

  def resolve(blocked_id:, **)
    @block = Block.new(
      user_id: current_user.id,
      blocked_id:
    )
    authorize!(@block, :create?)
    @block.tap(&:save!)
  end
end
