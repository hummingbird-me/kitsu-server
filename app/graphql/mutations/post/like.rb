# frozen_string_literal: true

class Mutations::Post::Like < Mutations::Base
	include FancyMutation

	description 'Like a post.'

	input do
		argument :post_id, ID,
			required: true,
			description: 'The id of the post entry.'
	end
	result Types::PostLike
	errors Types::Errors::NotAuthenticated,
		Types::Errors::NotFound,
		Types::Errors::NotAuthorized

	def ready?(post_id:, **)
		authenticate!
		@like = PostLike.new(
			user: current_user,
			post_id:
		)
		authorize!(@like, :create?)
		true
	end

	def resolve(**)
		@like.tap(&:save!)
	end
end
