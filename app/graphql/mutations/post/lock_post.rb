class Mutations::Post::LockPost < Mutations::Base
  argument :input,
    Types::Input::Post::Lock,
    required: true,
    description: 'Lock a Post.',
    as: :post

  field :post, Types::Post, null: true

  def load_post(value)
    post = ::Post.find(value.id)
    post.assign_attributes(value.to_model)
    post
  end

  def authorized?(post:)
    super(post, :update_lock?)
  end

  def resolve(post:)
    post.save

    if post.errors.any?
      Errors::RailsModel.graphql_error(post)
    else
      {
        post: post
      }
    end
  end
end
