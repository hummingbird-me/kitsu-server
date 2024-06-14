# frozen_string_literal: true

# Wraps the logic required to paginate feeds in GraphQL. This is effectively a cursor-based
# paginator but with some complexity to handle reverse ordering and the Relay spec's weirdness
# around combining the "first" and "last" arguments.
class FeedConnection < GraphQL::Pagination::Connection
  def nodes
    if reverse?
      node_sections[:current_page].reverse
    else
      node_sections[:current_page]
    end
  end

  # @return [Boolean]
  def has_next_page # rubocop:disable Naming/PredicateName
    node_sections[:next_page].any?
  end

  # @return [Boolean]
  def has_previous_page # rubocop:disable Naming/PredicateName
    node_sections[:previous_page].any?
  end

  def cursor_for(item)
    item && encode(item.attributes['bumped_at'])
  end

  private

  def encode(value)
    # Postgres stores dates with microsecond (6-decimal) precision
    super(value.strftime('%s.%6N'))
  end

  def decode(cursor)
    # Use BigDecimal to parse because Float loses precision
    Time.zone.at(BigDecimal(super(cursor)))
  end

  def before
    @before ||= begin
      before = super

      decode(before) if before
    end
  end

  def after
    @after ||= begin
      after = super

      decode(after) if after
    end
  end

  def node_sections
    @node_sections ||= base_nodes.each_with_object({
      previous_page: [],
      current_page: [],
      next_page: []
    }) do |node, sections|
      if (after && node.bumped_at >= after) ||
         (reverse? && sections[:current_page].size >= (last || first))
        sections[:previous_page] << node
      elsif (before && node.bumped_at <= before) ||
            (!reverse? && sections[:current_page].size >= (last || first))
        sections[:next_page] << node
      else
        sections[:current_page] << node
      end
    end
  end

  def base_nodes
    @base_nodes ||= begin
      nodes = items
      # These are inclusive filters so that we can check for a previous/next page
      nodes = nodes.where('bumped_at >= ?', before) if before
      nodes = nodes.where('bumped_at <= ?', after) if after
      # Limit is +2 to check for previous/next page
      nodes = nodes.limit(limit)
      # This isn't used for pagination, just to account for first+last weirdness
      nodes = nodes.offset(offset)
      # Reverse ordering is used for reverse pagination (solo "last" param) and then reversed after
      # loading to get the correct order
      nodes = nodes.order(**order)
      nodes.to_a
    end
  end

  def order
    if reverse?
      { bumped_at: :asc }
    else
      { bumped_at: :desc }
    end
  end

  def reverse?
    # We use reverse ordering to efficiently serve reverse pagination with the solo "last" param.
    # As you can see below in {#offset}, the Relay spec is weird when you combine the two, so it's
    # not used in that case.
    last && !first
  end

  def offset
    # If we have both first and last, we need the last *of* the first, according to the Relay spec.
    # Yes that is exactly as fucking weird as it sounds, don't use it.
    if first && last
      # Clamp so last > first won't get negative offset
      [first - (last || 0), 0].max
    else
      0
    end
  end

  def limit
    # We grab two extra records to check for previous/next page
    if last
      last + 2
    elsif first
      first + 2
    end
  end
end
