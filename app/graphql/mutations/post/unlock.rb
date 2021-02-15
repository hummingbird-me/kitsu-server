class Mutations::Post::Unlock < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Post::Unlock,
    required: true,
    description: 'Unlock a Post.',
    as: :post

  field :post, Types::Post, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_post(value)
    post = ::Post.find(value.id)
    post.assign_attributes(value.to_model)
    post
  end

  def authorized?(post:)
    super(post, :unlock?)
  end

  def resolve(post:)
    post.save!
    ModeratorActionLog.generate!(current_user, 'unlock', post)

    { post: post }
  end
end
