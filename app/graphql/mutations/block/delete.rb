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
    Types::Errors::NotFound,
    Types::Errors::NotAuthorized

  def ready?(block_id:, **)
    authenticate!
    @block = Block.find_by(id: block_id)
    return errors << Types::Errors::NotFound.build if @block.nil?
    authorize!(@block, :destroy?)
    true
  end

  def resolve(**)
    @block.destroy!
    @block
  end
end
