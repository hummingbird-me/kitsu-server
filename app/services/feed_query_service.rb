class FeedQueryService
  MEDIA_VERBS = %w[updated rated progressed].freeze
  POST_VERBS = %w[post comment follow review].freeze

  KIND_TO_FEED = {
    media_aggr: { posts: 'media_posts_aggr', media: 'media_media_aggr' },
    user_aggr: { posts: 'user_posts_aggr', media: 'user_media_aggr' },
    timeline: { posts: 'timeline_posts', media: 'timeline_media' },
    global: { posts: 'global_posts', media: 'global_media' }
  }.freeze

  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def list
    return @list if @list
    list = feed.activities
    list = list.page(id_lt: cursor) if cursor
    list = list.per(limit) if limit
    list = list.where_id(*id_query) if id_query
    list = list.mark(mark) if mark
    list = list.sfw if sfw_filter?
    list = list.blocking(blocked)
    @list = list
  end

  def feed
    return @feed if @feed
    kind = params.dig(:filter, :kind).try(:to_sym)
    group = params[:group].try(:to_sym)
    feed_name = KIND_TO_FEED.dig(group, kind) || group
    @feed = Feed.new(feed_name, params[:id])
  end

  private

  delegate :sfw_filter?, to: :user, allow_nil: true

  def cursor
    params.dig(:page, :cursor)
  end

  def limit
    params.dig(:page, :limit)&.to_i
  end

  def mark
    params[:mark]
  end

  def id_query
    return unless params.dig(:filter, :id).is_a? Hash
    operator, id = params.dig(:filter, :id).to_a.flatten
    [operator.to_sym, id]
  end

  def blocked
    Block.hidden_for(user)
  end
end
