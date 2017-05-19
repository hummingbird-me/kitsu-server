class LibraryEntriesController < ApplicationController
  include CustomControllerHelpers

  def authorize_operation(operation)
    has_permission = operation_scope.find_each.all? do |entry|
      LibraryEntryPolicy.new(current_user, entry).public_send(operation)
    end
    unless has_permission
      return render_jsonapi(serialize_error(401, 'Not permitted')), status: 401
    end
  end

  def bulk_delete
    authorize_operation(:destroy?)
    operation_scope.destroy_all
  end

  def bulk_update
    authorize_operation(:update?)
    operation_scope.update(update_params)
  end

  def update_params
    params.dig(:data, :attributes).permit(:status)
  end

  def operation_scope
    LibraryEntry.where(operation_filters)
  end

  def operation_filters
    params[:filter].transform_values { |v| v.split(',') }
                   .select { |k, _| %i[id user_id].include?(k) }
  end
end
