class FeedQueryService
  MEDIA_VERBS = %w[updated rated progressed].freeze
  POST_VERBS = %w[post comment follow review].freeze

  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def list
    return @list if @list
    list = if split_feeds?
             feed.activities
           else
             feed.activities(filter: kind_filter)
           end
    list = list.page(id_lt: cursor) if cursor
    list = list.per(limit) if limit
    list = list.where_id(*id_query) if id_query
    list = list.mark(mark) if mark
    list = list.sfw if sfw_filter?
    list = list.blocking(blocked)
    if kind_select && !split_feeds?
      list = list.select(kind_select[:ratio], &kind_select[:proc])
    end
    @list = list
  end

  def feed
    if split_feeds?
      return @feed if @feed
      feed_name = params[:group].sub(/_aggr\z/, '')
      @feed = Feed.class_for(feed_name).new(params[:id])
    else
      # Just use the basic SreamFeed class for the old system
      @feed ||= Feed::StreamFeed.new(params[:group], params[:id])
    end
  end

  def split_feed
    return @split_feed if @split_feed
    feed_name = params[:group].sub(/_aggr\z/, '')
    @split_feed = Feed.class_for(feed_name).new(params[:id])
  end

  private

  delegate :sfw_filter?, to: :user, allow_nil: true

  def split_feeds?
    params.key?(:_split_feeds)
  end

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

  def kind_filter
    params.dig(:filter, :kind)
  end

  def kind_select
    @kind_filter ||=
      case kind_filter
      when 'media'
        {
          ratio: 0.8,
          proc: ->(act) do
            if MEDIA_VERBS.include?(act['verb'])
              true
            else
              throw :remove_group
            end
          end
        }
      when 'posts'
        {
          ratio: 0.2,
          proc: ->(act) do
            if POST_VERBS.include?(act['verb'])
              true
            else
              throw :remove_group
            end
          end
        }
      end
  end

  def blocked
    Block.hidden_for(user)
  end
end
