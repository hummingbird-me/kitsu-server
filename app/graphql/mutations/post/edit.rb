# frozen_string_literal: true

class Mutations::Post::Edit < Mutations::Base
	include FancyMutation

	description 'Edit a post'

	input do
		argument :id, ID,
			required: true,
			description: 'The id of the post you want to edit.'
		argument :content, String,
			required: false,
			description: 'The content of the post'
		argument :media_id, ID,
			required: false,
			description: 'The related media of this post'
		argument :media_type,
			Types::Enum::MediaType,
			required: false,
			description: 'The type of the related media'
		argument :is_spoiler, Boolean,
			required: false,
			default_value: false,
			as: :spoiler,
			description: 'If the post should be marked as spoiler'
		argument :is_nsfw, Boolean,
			required: false,
			default_value: false,
			as: :nsfw,
			description: 'If the post should be marked as NSFW'
		argument :spoiled_unit_id, ID,
			required: false,
			description: 'The ID of the related unit (chapter/episode)'
		argument :spoiled_unit_type, String,
			required: false,
			description: 'The Type of the related unit (chapter/episode)'
		argument :embed,
			Types::Map,
			required: false,
			description: 'The data for the embed.'
	end

	result Types::Post
	errors Types::Errors::NotAuthenticated,
		Types::Errors::NotAuthorized,
		Types::Errors::NotFound,
		Types::Errors::Validation

	def ready?(id:, **input)
		authenticate!

		# Check if the tagged media is valid
		unless input[:media_id].nil? ^ input[:media_type].nil?
			case input[:media_type]
				when 'Anime' then @media = Anime.find_by(id: input[:media_id])
				when 'Manga' then @media = Manga.find_by(id: input[:media_type])
				else @media = nil
			end
			return errors << Types::Errors::NotFound.build(path: %w[input 
					media_id media_type]) if (@media.nil? && !input[:media_id].nil?) 
		else
			return errors << Types::Errors::Validation.build(path: %w[input media_id media_type],
				message: 'You have to provide both mediaId and mediaType.') 
		end

		# Check if the spoiled unit is valid
		unless input[:spoiled_unit_id].nil? ^ input[:spoiled_unit_type].nil?      
			case input[:spoiled_unit_type]
				when 'Episode' then @unit = Episode.find_by(id: input[:spoiled_unit_id], media_id: input[:media_id])
				when 'Chapter' then @unit = Chapter.find_by(id: input[:spoiled_unit_id], media_id: input[:media_id])
				else @unit = nil
			end
			return errors << Types::Errors::NotFound.build(path: %w[input 
					spoiled_unit_id spoiled_unit_type]) if (@unit.nil? && !input[:spoiled_unit_id].nil?) 
		else
			return errors << Types::Errors::Validation.build(path: %w[input 
					spoiled_unit_id spoiled_unit_type],
					message: 'You have to provide both spoiledUnitId and spoiledUnitType.') 
		end

		# Find the post
		@post = Post.find_by(id:)
		return errors << Types::Errors::NotFound.build(path: %w[input id]
			) if @post.nil? 

		# Authorize it with the policy
		authorize!(@post, :update?)
		true  
	end

	def resolve(**input)
		@post.update!(**input)
		@post
	end
end
