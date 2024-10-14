# frozen_string_literal: true

class Mutations::Comment::Like < Mutations::Base
	include FancyMutation

	description 'Like a comment.'

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
		@like = CommentLike.new(
			user: current_user,
			comment_id:
		)
		authorize!(@like, :create?)
		true
	end

	def resolve(**)
		@like.tap(&:save!)
	end
end
