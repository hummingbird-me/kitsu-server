class LibraryPaginator < OffsetPaginator
  private

  def verify_pagination_params
    raise JSONAPI::Exceptions::InvalidPageValue.new(:limit, @limit) if @limit < 1

    if @limit > 500
      raise JSONAPI::Exceptions::InvalidPageValue.new(:limit, @limit,
        detail: 'Limit exceeds maximum page size of 500.')
    end

    raise JSONAPI::Exceptions::InvalidPageValue.new(:offset, @offset) if @offset < 0
  end
end
