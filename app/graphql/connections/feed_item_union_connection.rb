class Connections::FeedItemUnionConnection < Connections::BaseConnection
  attr_reader :mark, :user

  def initialize(items, **args)
    super(items, args)

    @mark = args[:mark]
    @user = User.current
  end

  def nodes
    @nodes ||= list.to_a
  end

  def has_next_page
    @has_next_page = nodes.count == first
  end

  # There is no backwards check for feeds.
  def has_previous_page
    false
  end

  def cursor_for(item)
    item&.id
  end

  private

  def list
    return @list if @list

    list = items
    list = list.per(first_value)
    list = list.page(id_lt: after_value) if after_value
    list = list.sfw if sfw_filter?
    list = list.mark if mark

    @list = list
  end

  def sfw_filter?
    return true if user.blank?

    user.sfw_filter?
  end
end
