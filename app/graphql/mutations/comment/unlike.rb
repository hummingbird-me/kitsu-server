# frozen_string_literal: true

class Mutations::Comment::Unlike < Mutations::Base
	include FancyMutation

	description 'Unlike a comment.'

	input do
		argument :comment_id, ID,
			required: true,
			description: 'The id of the comment.'
	end
	result Types::CommentLike
	errors Types::Errors::NotAuthenticated,
		Types::Errors::NotFound,
		Types::Errors::NotAuthorized

	def ready?(comment_id:, **)
		authenticate!
		@like = CommentLike.find_by(
			comment_id:,
			user: current_user
		)
		return errors << Types::Errors::NotFound.build if @like.nil?
		authorize!(@like, :destroy?)
		true
	end

	def resolve(**)
		@like.destroy!
		@like
	end
end
