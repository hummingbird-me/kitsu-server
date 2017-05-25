class LibraryEntryProcessor < JSONAPI::Processor
  def find
    result = super

    # Send filters to #section_counts method.
    filters = params[:filters].reject { |k, _| k == :status }
    verified_filters = resource_klass.verify_filters(filters, context)
    counts = resource_klass.status_counts(verified_filters, context: context)
    result.meta[:status_counts] = counts

    result
  end
end
