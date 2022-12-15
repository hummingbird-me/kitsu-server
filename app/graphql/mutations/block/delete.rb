class Mutations::Block::Delete < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::GenericDelete,
    required: true,
    description: 'Remove a block entry.',
    as: :block

  field :block, Types::GenericDelete, null: true

  def load_block(value)
    Block.find(value.id)
  end

  def authorized?(block:)
    return true if BlockPolicy.new(context[:token], block).destroy?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
  end

  def resolve(block:)
    block.destroy!

    { block: { id: block.id } }
  end
end
