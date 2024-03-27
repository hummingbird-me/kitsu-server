# frozen_string_literal: true

class Mutations::Post::Unlike < Mutations::Base
	include FancyMutation

	description 'Unlike a post.'

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
		@like = PostLike.find_by(
			post_id: post_id,
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
