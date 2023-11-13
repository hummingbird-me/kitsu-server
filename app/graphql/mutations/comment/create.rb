# frozen_string_literal: true

class Mutations::Comment::Create < Mutations::Base
  include FancyMutation

  description 'Create a comment'

  # TODO: Add Attachments
  input do
    argument :post_id, ID,
      required: true,
      description: 'The ID of the targeted post'
    argument :content, String,
      required: true,
      description: 'The content of the comment'
    argument :parent_id, ID,
      required: false,
      description: 'A parent comment to which this this will become a reply'
    argument :embed,
      Types::Map,
      required: false,
      description: 'The data for the embed.'
  end

  result Types::Comment
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound,
    Types::Errors::Validation

  def ready?(post_id:, **input)
    authenticate!

    # First check if we have a parent comment.
    # If so, we need to be sure it's valid.
    unless input[:parent_id].nil?
      @parent = Comment.find_by(id: input[:parent_id])
      return errors << Types::Errors::NotFound.build(path: %w[input 
        parent_id]) if @parent.nil? 
    end

    # Then check if the post exists

    @post = Post.find_by(id: post_id)
      return errors << Types::Errors::NotFound.build(path: %w[input 
        post_id]) if @post.nil? 
    # Then create the comment
    @comment = Comment.new(
      **input,
      user_id: current_user&.id,
      post_id:
    )
    # Authorize it with the policy
    authorize!(@comment, :create?)
    true  
  end

  def resolve(**)
    @comment.tap(&:save!)
  end
end
