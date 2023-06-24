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
    Types::Errors::NotFound,
    Types::Errors::NotAuthorized

  def ready?(blocked_id:, **)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    @block_user = User.find_by(id: blocked_id)
    return errors << Types::Errors::NotFound.build(path: %w[input blocked_id]) if @block_user.nil?
    @block = Block.new(
      user_id: current_user.id,
      blocked_id:
    )
    authorize!(@block, :create?)
    true
  end

  def resolve(**)
    @block.tap(&:save!)
  end
end
