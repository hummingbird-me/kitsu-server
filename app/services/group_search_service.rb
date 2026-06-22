# frozen_string_literal: true

class GroupSearchService < TypesenseSearchService
  # Runs the search and returns the list of matching groups in order by their
  # relevance to the query.
  #
  # @return [Array<Group>] the list of matching groups
  def to_a
    result_ids.map do |id|
      result_groups[id.to_i]
    end
  end

  def query_results
    @query_results ||= query.include_fields(:id).load
  end

  # Exclude NSFW groups.  Mirrors GroupsIndex::Group.sfw so the PolicyScope can
  # resolve identically against either backend.
  def sfw
    @sfw = true
    self
  end

  # Limit to the groups visible to the given user.  Mirrors
  # GroupsIndex::Group.visible_for: a user can see public (open/restricted)
  # groups plus any closed group they belong to.
  def visible_for(user)
    @visible = true
    @visible_user = user
    self
  end

  private

  def result_groups
    @result_groups ||= Group.where(id: result_ids).index_by(&:id)
  end

  def result_ids
    @result_ids ||= query_results.hits.map { |res| res.document['id'] }
  end

  def query
    @query ||= begin
      query = TypesenseGroupsIndex.search(
        query: filters[:query]&.join(' ') || '',
        query_by: {
          'name' => 4,
          'tagline' => 2,
          'about' => 1
        }
      )
      query = apply_sfw_filter_to(query)
      query = apply_visibility_filter_to(query)
      query = apply_auto_filter_for(query, :privacy)
      query = apply_featured_filter_to(query)
      query = apply_category_filter_to(query)
      query = apply_order_to(query)
      query = apply_page_to(query)
      query = apply_per_to(query)
      query
    end
  end

  def apply_sfw_filter_to(scope)
    return scope unless @sfw

    scope.filter('is_nsfw:=false')
  end

  def apply_visibility_filter_to(scope)
    return scope unless @visible

    group_ids = visible_group_ids
    if group_ids.present?
      scope.filter("(id:=[#{group_ids.join(',')}] || privacy:=[open,restricted])")
    else
      scope.filter('privacy:=[open,restricted]')
    end
  end

  def visible_group_ids
    return [] unless @visible_user

    GroupMember.joins(:group).merge(Group.closed).for_user(@visible_user).pluck(:group_id)
  end

  def apply_featured_filter_to(scope)
    return scope unless filters.key?(:featured)

    value = filters[:featured]
    value = value.last if value.is_a?(Array)
    scope.filter("featured:=#{value ? 'true' : 'false'}")
  end

  def apply_category_filter_to(scope)
    return scope if filters[:category].blank?

    category_ids = Array(filters[:category]).map { |category| category.try(:id) || category }
    scope.filter("category_id:=[#{category_ids.join(',')}]")
  end

  def apply_order_to(scope)
    return scope unless orders

    improved_orders = orders.flat_map do |field, direction|
      case field
      when '_text_match'
        [['_text_match(buckets: 6)', direction], ['members_count', direction]]
      when 'last_activity_at'
        [['last_activity_at.timestamp', direction]]
      else
        [[field, direction]]
      end
    end
    scope.sort(improved_orders.to_h)
  end
end
