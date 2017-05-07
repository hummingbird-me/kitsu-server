# Parse getstream.io webhook reqest
class GetstreamWebhookService
  attr_reader :activity, :feed_id, :actor_id

  def initialize(feed)
    #TODO Experiment will there be multiple activities
    @activity = feed['new'].first
    @feed_id = feed['feed'].split(':').last
    @actor_id = @activity['actor'].split(':').last
  end

  # Find correspond user from feed id
  def feed_target
    User.find_by(id: feed_id)
  end

  # Express activity of this feed in desired locale
  def stringify_activity
    locale = feed_target&.language || 'en'
    actor_name = User.find_by(id: actor_id)&.name

    case activity['verb']
    when 'follow'
      I18n.t(:followed, scope: [:notifications], actor: actor_name, locale: locale)
    when 'post'
      I18n.t(:post_mentioned, scope: [:notifications], actor: actor_name, locale: locale)
    when 'post_like'
      I18n.t(:post_like, scope: [:notifications], actor: actor_name, locale: locale)
    when 'comment_like'
      I18n.t(:comment_like, scope: [:notifications], actor: actor_name, locale: locale)
    when 'comment'
      # Checking what exactly this feed is refering to
      # reply in post, reply in comment, mention in comment, mention in post
      reply_to_user_id = activity['reply_to_user'].split(':').last
      reply_to_type = activity['reply_to_type']

      if feed_id == reply_to_user_id
        if reply_to_type == 'post'
          I18n.t(:post_replied, scope: [:notifications], actor: actor_name, locale: locale)
        else
          I18n.t(:comment_replied, scope: [:notifications], actor: actor_name, locale: locale)  
        end
      else
        #TODO: If post is belongs to feed target. Should be reply to post
        I18n.t(:comment_mentioned, scope: [:notifications], actor: actor_name, locale: locale)  
      end
    end
  end
end