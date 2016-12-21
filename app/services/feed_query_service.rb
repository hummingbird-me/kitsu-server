class FeedQueryService
  MEDIA_VERBS = %w[updated rated progressed reviewed]
  POST_VERBS = %w[post comment follow]

  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def list
    return @list if @list
    list = feed.activities
    list = list.page(id_lt: cursor) if cursor
    list = list.limit(limit) if limit
    list = list.where_id(*id_query) if id_query
    list = list.mark(mark) if mark
    list = list.sfw if sfw_filter?
    list = list.blocking(blocked)
    list = list.select(kind_filter[:ratio], &kind_filter[:proc]) if kind_filter
    @list = list
  end

  def feed
    @feed ||= Feed.new(params[:group], params[:id])
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

  def kind_filter
    kind = params.dig(:filter, :kind)
    @kind_filter ||= case kind
      when 'media'
        {
          ratio: 0.8,
          proc: -> (act) {
            throw :remove_group unless MEDIA_VERBS.include?(act.verb)
          }
        }
      when 'posts'
        {
          ratio: 0.2,
          proc: -> (act) {
            throw :remove_group unless POST_VERBS.include?(act.verb)
          }
        }
    end
  end

  def blocked
    Block.hidden_for(user)
  end
end
