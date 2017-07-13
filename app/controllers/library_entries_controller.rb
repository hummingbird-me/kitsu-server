class LibraryEntriesController < ApplicationController
  include CustomControllerHelpers

  def authorize_operation(operation)
    has_permission = operation_scope.find_each.all? do |entry|
      LibraryEntryPolicy.new(current_user, entry).public_send(operation)
    end
    if has_permission
      true
    else
      render_jsonapi(serialize_error(401, 'Not permitted'), status: 401)
      false
    end
  end

  def issues
    authenticate_user!
    missing_library_engagement = {
      rating_ids: [],
      reaction_ids: [],
      attributes_ids: []
    }

    library_entries = LibraryEntry.includes(
      :media_reaction,
      media: :media_attribute_votes
    ).where(user: user)

    library_entries.each do |entry|
      missing_library_engagement[:rating_ids] << entry.id if entry.rating.nil?
      missing_library_engagement[:reaction_ids] << entry.id if entry.media_reaction.nil?
      votes = entry.media.media_attribute_votes.select { |mv| mv.vote == :unvoted }
      missing_library_engagement[:attributes_ids] << entry.id unless votes.empty?
    end
    render json: missing_library_engagement
  end

  def bulk_delete
    return unless authorize_operation(:destroy?)
    # Disable syncing of full-library deletes
    if params.dig(:filter, :user_id).present?
      LinkedAccount.disable_syncing_for(user) do
        operation_scope.destroy_all
      end
    else
      operation_scope.destroy_all
    end
    render nothing: true, status: 204
  end

  def bulk_update
    return unless authorize_operation(:update?)
    entries = operation_scope
    entries.each { |r| r.update(update_params) }
    render json: serialize_entries(entries)
  end

  def update_params
    params.dig(:data, :attributes).permit(:status)
  end

  def operation_scope
    LibraryEntry.where(operation_filters)
  end

  def operation_filters
    params.require(:filter).permit(:id, :user_id)
          .transform_values { |v| v.split(',') }
          .select { |k, _| %w[id user_id].include?(k) }
  end

  private

  def serialize_entries(entries)
    serializer.serialize_to_hash(wrap_in_resources(entries))
  end

  def wrap_in_resources(entries)
    entries.map { |entry| LibraryEntryResource.new(entry, context) }
  end

  def serializer
    JSONAPI::ResourceSerializer.new(LibraryEntryResource)
  end
end
