# frozen_string_literal: true

class Mutations::Comment::Edit < Mutations::Base
	include FancyMutation

	description 'Edit a comment'

	# TODO: Add attachments
	input do
		argument :id, ID,
			required: true,
			description: 'The id of the comment you want to edit.'
		argument :content, String,
			required: false,
			description: 'The content of the comment'
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

	def ready?(id:, **input)
		authenticate!

		# Find the comment
		@comment = Comment.find_by(id:)
		return errors << Types::Errors::NotFound.build(path: %w[input id]
			) if @comment.nil? 

		# Authorize it with the policy
		authorize!(@comment, :update?)
		true  
	end

	def resolve(**input)
		@comment.update!(**input)
		@comment
	end
end
