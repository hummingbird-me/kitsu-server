class LibraryPaginator < OffsetPaginator
  private

  def verify_pagination_params
    if @limit < 1
      raise JSONAPI::Exceptions::InvalidPageValue.new(:limit, @limit)
    end

    if @limit > 500
      raise JSONAPI::Exceptions::InvalidPageValue.new(:limit, @limit,
        detail: 'Limit exceeds maximum page size of 500.')
    end

    if @offset < 0
      raise JSONAPI::Exceptions::InvalidPageValue.new(:offset, @offset)
    end
  end
end
