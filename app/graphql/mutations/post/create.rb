class Mutations::Post::Create < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Post::Create,
    required: true,
    description: 'Create a Post',
    as: :post

  field :post, Types::Post, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_post(value)
    Post.new(value.to_model)
  end

  def authorized?(post:)
    return true if PostPolicy.new(context[:token], post).create?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
  end

  def resolve(post:)
    post.save!

    { post: post }
  end
end
