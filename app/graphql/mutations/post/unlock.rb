class Mutations::Post::Unlock < Mutations::Base
  include FancyMutation

  description 'Unock a post'

  input do
    argument :id, ID,
      required: true
  end

  result Types::Post
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound
  
  def ready?(id:, **)
    authenticate!
    @post = Post.find_by(id:)
    return errors << Types::Errors::NotFound.build if @post.nil?
    @post.assign_attributes(
      locked_at: nil,
      locked_reason: nil,
      locked_by: nil
    )
    authorize!(@post, :unlock?)
    true
  end

  def resolve(**)
    @post.tap(&:save!)
    ModeratorActionLog.generate!(current_user, 'unlock', @post)
    @post
  end
end