class Mutations::Block::Create < Mutations::Base

  argument :input,
    Types::Input::Block::Create,
    required: true,
    description: 'Block a user.',
    as: :block
  
  field :block, Types::Block, null: true

  def load_block(value)
    Block.new(value.to_model)
  end

  def authorized?(block:)
    return true if BlockPolicy.new(context[:token], block).create?

  [false, {
    errors: [
      { message: 'Not Authorized', code: 'NotAuthorized' }
    ]
  }]
  end

  def resolve(block:)
    block.save!

    { block: block }
  end
end