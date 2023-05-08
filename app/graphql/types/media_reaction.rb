# frozen_string_literal: true

class Types::MediaReaction < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A simple review that is 140 characters long expressing how you felt about a media'

  field :id, ID, null: false

  field :author, Types::Profile,
    null: false,
    description: 'The author who wrote this reaction.',
    method: :user

  def author
    Loaders::RecordLoader.for(User, token: context[:token]).load(object.user_id)
  end

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this reaction.'

  def media
    Loaders::RecordLoader.for(object.media_type.constantize,
      token: context[:token]).load(object.media_id)
  end

  field :library_entry, Types::LibraryEntry,
    null: false,
    description: 'The library entry related to this reaction.'

  def library_entry
    Loaders::RecordLoader.for(LibraryEntry, token: context[:token]).load(object.library_entry_id)
  end

  field :progress, Integer,
    null: false,
    description: 'When this media reaction was written based on media progress.'

  field :reaction, String,
    null: false,
    description: 'The reaction text related to a media.'

  field :likes, Types::Profile.connection_type, null: false do
    description 'Users that have liked this reaction'
    argument :sort, Loaders::MediaReactionVotesLoader.sort_argument, required: false
  end

  def likes(sort: [{ on: :created_at, direction: :desc }])
    Loaders::MediaReactionVotesLoader.connection_for({
      find_by: :media_reaction_id,
      sort:
    }, object.id).then do |likes|
      Loaders::RecordLoader.for(User, token: context[:token]).load_many(likes.map(&:user_id))
    end
  end

  field :has_liked, Boolean,
    null: false,
    description: 'Whether you have liked this media reaction'

  def has_liked
    return false if current_user.blank?
    return true if current_user.id == object.user_id

    Loaders::RecordLoader.for(
      MediaReactionVote,
      column: :media_reaction_id,
      token: current_token,
      where: { user_id: current_user&.id }
    ).load(object.id).then(&:present?)
  end
end
