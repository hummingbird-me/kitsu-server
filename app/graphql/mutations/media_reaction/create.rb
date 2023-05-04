# frozen_string_literal: true

class Mutations::MediaReaction::Create < Mutations::Base
  include FancyMutation

  description 'Share a brief reaction to a media, tied to your library entry'

  input do
    argument :library_entry_id, ID,
      required: true,
      description: 'The ID of the entry in your library to react to'
    argument :reaction, String,
      required: true,
      description: 'The text of the reaction to the media'
  end
  result Types::MediaReaction
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound,
    Types::Errors::Validation

  def ready?(library_entry_id:, **)
    authenticate!

    @library_entry = current_user.library_entries.find_by(id: library_entry_id)
    if @library_entry.nil?
      return errors << Types::Errors::NotFound.build(path: %w[input
                                                              library_entry_id])
    end

    true
  end

  def resolve(reaction:, **)
    reaction = MediaReaction.new(
      "#{@library_entry.media_type.underscore}_id": @library_entry.media_id,
      user_id: current_user.id,
      library_entry: @library_entry,
      reaction:
    )
    authorize!(reaction, :create?)

    reaction.tap(&:save!)
  rescue ActiveRecord::RecordInvalid => e
    errors.push(*Types::Errors::Validation.for_record(e.record, prefix: 'input'))
  end
end
