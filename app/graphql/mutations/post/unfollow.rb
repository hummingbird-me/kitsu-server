# frozen_string_literal: true

class Mutations::Post::Unfollow < Mutations::Base
	include FancyMutation

	description 'Unfollow a post.'

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
		@follow = PostFollow.find_by(
			post_id: post_id,
			user: current_user
		)
		return errors << Types::Errors::NotFound.build if @follow.nil?
		authorize!(@follow, :destroy?)
		true
	end

	def resolve(**)
		@follow.destroy!
		@follow
	end
end
