# frozen_string_literal: true

class Mutations::Block::Delete < Mutations::Base
  include FancyMutation

  description 'Unblock a user'

  input do
    argument :block_id, ID,
      required: true,
      description: 'The id of the block.'
  end
  result Types::Block
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound

  def ready?(block_id:, **)
    authenticate!
    @block = Block.find(block_id)
    authorize!(@block, :destroy?)
    true
  end

  def resolve(**)
    @block.destroy!
    @block
  end
end
