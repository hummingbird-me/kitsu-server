# frozen_string_literal: true

class Mutations::Post::Delete < Mutations::Base
	include FancyMutation

	description 'Delete a post.'

	input do
		argument :id, ID,
			required: true,
			description: 'The id of the post entry.'
	end
	result Types::Post
	errors Types::Errors::NotAuthenticated,
		Types::Errors::NotFound,
		Types::Errors::NotAuthorized

	def ready?(id:, **)
		authenticate!
		@post = Post.find_by(id:)
		return errors << Types::Errors::NotFound.build if @post.nil?
		authorize!(@post, :destroy?)
		true
	end

	def resolve(**)
		@post.destroy!
		@post
	end
end
