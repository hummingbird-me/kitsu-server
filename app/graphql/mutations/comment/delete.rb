# frozen_string_literal: true

class Mutations::Comment::Delete < Mutations::Base
	include FancyMutation

	description 'Delete a comment.'

	input do
		argument :id, ID,
			required: true,
			description: 'The id of the comment entry.'
	end
	result Types::Comment
	errors Types::Errors::NotAuthenticated,
		Types::Errors::NotFound,
		Types::Errors::NotAuthorized

	def ready?(id:, **)
		authenticate!
		@comment = Comment.find_by(id:)
		return errors << Types::Errors::NotFound.build if @comment.nil?
		authorize!(@comment, :destroy?)
		true
	end

	def resolve(**)
		@comment.destroy!
		@comment
	end
end
