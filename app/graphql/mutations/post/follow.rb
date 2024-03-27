# frozen_string_literal: true

class Mutations::Post::Follow < Mutations::Base
	include FancyMutation

	description 'Follow a post.'

	input do
		argument :post_id, ID,
			required: true,
			description: 'The id of the post entry.'
	end
	result Types::PostFollow
	errors Types::Errors::NotAuthenticated,
		Types::Errors::NotFound,
		Types::Errors::NotAuthorized

	def ready?(post_id:, **)
		authenticate!
		@follow = PostFollow.new(
			user: current_user,
			post_id:
		)
		authorize!(@follow, :create?)
		true
	end

	def resolve(**)
		@follow.tap(&:save!)
	end
end
