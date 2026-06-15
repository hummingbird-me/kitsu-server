# frozen_string_literal: true

class UserSearchService < TypesenseSearchService
  # Runs the search and returns the list of matching users in order by their
  # relevance to the query.
  #
  # @return [Array<User>] the list of matching users
  def to_a
    result_ids.map do |id|
      result_users[id.to_i]
    end
  end

  def query_results
    @query_results ||= query.include_fields(:id).load
  end

  # Exclude soft-deleted users.  Mirrors UsersIndex::User.active so the
  # PolicyScope can resolve identically against either backend.
  def active
    @active = true
    self
  end

  # Exclude the given user ids.  Mirrors UsersIndex::User.blocking.
  def blocking(ids)
    @blocking_ids = ids
    self
  end

  private

  def result_users
    @result_users ||= User.where(id: result_ids).index_by(&:id)
  end

  def result_ids
    @result_ids ||= query_results.hits.map { |res| res.document['id'] }
  end

  def query
    @query ||= begin
      query = TypesenseUsersIndex.search(
        query: filters[:query]&.join(' ') || '',
        query_by: {
          'name' => 2,
          'past_names' => 1
        }
      )
      query = apply_active_filter_to(query)
      query = apply_blocking_filter_to(query)
      query = apply_order_to(query)
      query = apply_page_to(query)
      query = apply_per_to(query)
      query
    end
  end

  def apply_active_filter_to(scope)
    return scope unless @active

    scope.filter('is_deleted:=false')
  end

  def apply_blocking_filter_to(scope)
    return scope if @blocking_ids.blank?

    scope.filter("id:!=[#{@blocking_ids.join(',')}]")
  end

  def apply_order_to(scope)
    return scope unless orders

    # Replace _text_match with _text_match(buckets: 6),followers_count in the
    # same direction.  This surfaces the more prominent accounts first, which is
    # almost always what the searcher is looking for.
    improved_orders = orders.flat_map do |field, direction|
      if field == '_text_match'
        [['_text_match(buckets: 6)', direction], ['followers_count', direction]]
      else
        [[field, direction]]
      end
    end
    scope.sort(improved_orders.to_h)
  end
end
