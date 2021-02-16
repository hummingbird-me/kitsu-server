class Mutations::Post::Lock < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Post::Lock,
    required: true,
    description: 'Lock a Post.',
    as: :post

  field :post, Types::Post, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_post(value)
    post = ::Post.find(value.id)
    post.assign_attributes(value.to_model)
    post
  end

  def authorized?(post:)
    super(post, :lock?)
  end

  def resolve(post:)
    post.save!
    ModeratorActionLog.generate!(current_user, 'lock', post)

    { post: post }
  end
end
