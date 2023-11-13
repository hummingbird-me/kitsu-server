# frozen_string_literal: true

class Mutations::Post::Create < Mutations::Base
  include FancyMutation

  description 'Create a post'

  # TODO: Add Attachments
  input do
    argument :content, String,
      required: true,
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
    argument :target_user_id, ID,
      required: false,
      description: 'The user whom the post is targeted to'
    argument :target_group_id, ID,
      required: false,
      description: 'The group which the post is targeted to'
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

  def ready?(**input)
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
    
    # And finally check if the post has a target and if they're valid
    if !input[:target_user_id].nil?
      return errors << Types::Errors::NotFound.build(path: %w[input 
          target_user_id]) if User.find_by(id: input[:target_user_id]).nil?
    elsif !input[:target_group_id].nil?
      return errors << Types::Errors::NotFound.build(path: %w[input 
          target_group_id]) if Group.find_by(id: input[:target_group_id]).nil?
    else
    end

    # Then create the post
    @post = Post.new(**input, user_id: current_user&.id)

    # Authorize it with the policy
    authorize!(@post, :create?)
    true  
  end

  

  def resolve(**)
    @post.tap(&:save!)
  end
end
