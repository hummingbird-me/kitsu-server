class Mutations::Post::Lock < Mutations::Base
  include FancyMutation

  description 'Lock a post'

  input do
    argument :id, ID,
      required: true
    argument :locked_reason,
      Types::Enum::LockedReason,
      required: true,
      description: 'The reason why this post got locked.'
  end

  result Types::Post
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound
  
  def ready?(id:, locked_reason:, **)
    authenticate!
    @post = Post.find_by(id:)
    return errors << Types::Errors::NotFound.build if @post.nil?
    @post.assign_attributes(
      locked_at: DateTime.current,
      locked_reason:,
      locked_by: current_user
    )
    authorize!(@post, :lock?)
    true
  end

  def resolve(**)
    @post.tap(&:save!)
    ModeratorActionLog.generate!(current_user, 'lock', @post)
    @post
  end
end
