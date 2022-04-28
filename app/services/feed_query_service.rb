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
    list = feed.activities
    list = list.page(id_lt: cursor) if cursor
    list = list.per(limit) if limit
    list = list.where_id(*id_query) if id_query
    list = list.mark(mark) if mark
    list = list.sfw if sfw_filter?
    if Flipper[:feed_following_filter].enabled?(User.current)
      list = list.only_following(user.id) if only_following?
    end
    list = list.blocking(blocked)
    list = list.select(kind_select[:ratio], &kind_select[:proc]) if kind_select
    if Flipper[:feed_reasons].enabled?(User.current)
      list = list.map(&method(:annotate_with_reason)) if feed.is_a?(TimelineFeed)
    end
    @list = list
  end

  def feed
    @feed ||= FeedRouter.route(params[:group], params[:id])
  end

  private

  def sfw_filter?
    # Enables the SFW filter for SFW media and global feeds (in addition to your settings)
    user&.sfw_filter? || feed.try(:media).try(:sfw?) || params[:group] == 'global'
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

  def only_following?
    params.dig(:filter, :following)
  end

  def followed
    @followed ||= Set.new(Follow.where(follower_id: user.id).pluck(:followed_id))
  end

  def groups
    @groups ||= Set.new(GroupMember.where(user_id: user.id).pluck(:group_id))
  end

  def annotate_with_reason(act)
    if act['target'].is_a?(Post)
      user_id = act['target'].user_id
      group_id = act['target'].target_group_id
      act['reason'] = 'media'
      act['reason'] = 'follow' if followed.include?(user_id)
      act['reason'] = 'follow' if user.id == user_id
      act['reason'] = 'group' if groups.include?(group_id)
    end
    act
  end

  def blocked
    Block.hidden_for(user)
  end
end
