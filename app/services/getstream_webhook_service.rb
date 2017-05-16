# Parse getstream.io webhook reqest
class GetstreamWebhookService
  attr_reader :activities, :activity, :feed_id, :actor_id

  def initialize(feed)
    @activites = feed['new']
    @activity = feed['new'].first
    @feed_id = feed['feed'].split(':').last
    @actor_id = @activity['actor'].split(':').last
  end

  # Find correspond user from feed id
  def feed_target
    User.find_by(id: feed_id)
  end

  # Get the corresponding feed url
  def feed_url
    client_url = 'https://kitsu.io'

    return "#{client_url}/notifications" if activities.length > 1

    activity = activities.first
    model_type, model_id = activity['foreign_id'].split(':')
    path = ''
    case model_type
    when 'Follow'
      path = "/users/#{activity['actor'].split(':').last}"
    when 'Post'
      path = "/posts/#{model_id}"
    when 'Comment'
      path = "/comments/#{model_id}"
    when 'PostLike'
      target_id = activity['target'].split(':').last
      path = "/posts/#{target_id}"
    when 'CommentLike'
      target_id = activity['target'].split(':').last
      path = "/comments/#{target_id}"
    end

    "#{client_url}#{path}"
  end

  # Express activity of this feed in desired locale
  def stringify_activity
    I18n.locale = (feed_target&.language || 'en').to_sym
    actor_name = User.find_by(id: actor_id)&.name
    activity_str = {}

    case activity['verb']
    when 'follow'
      activity_str[locale] = I18n.t(:followed,
        scope: [:notifications],
        actor: actor_name)
    when 'post'
      activity_str[locale] = I18n.t(:post_mentioned,
        scope: [:notifications],
        actor: actor_name)
    when 'post_like'
      activity_str[locale] = I18n.t(:post_like,
        scope: [:notifications],
        actor: actor_name)
    when 'comment_like'
      activity_str[locale] = I18n.t(:comment_like,
        scope: [:notifications],
        actor: actor_name)
    when 'comment'
      # Checking what exactly this feed is refering to
      # reply in post, reply in comment, mention in comment, mention in post
      reply_to_user_id = activity['reply_to_user'].split(':').last
      reply_to_type = activity['reply_to_type']

      activity_str[locale] = if feed_id == reply_to_user_id
                               if reply_to_type == 'post'
                                 I18n.t(:post_replied,
                                   scope: [:notifications],
                                   actor: actor_name)
                               else
                                 I18n.t(:comment_replied,
                                   scope: [:notifications],
                                   actor: actor_name)
                               end
                             else
                               I18n.t(:comment_mentioned,
                                 scope: [:notifications],
                                 actor: actor_name)
                             end
    end

    activity_str
  end
end
