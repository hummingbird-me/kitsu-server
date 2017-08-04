# Parse getstream.io webhook reqest
class GetstreamWebhookService
  attr_reader :activities, :activity, :feed_id, :feed_target, :locale, :actor_id

  def initialize(feed)
    @activities = feed['new']
    @feed_id = feed['feed'].split(':').last
    @feed_target = User.find_by(id: @feed_id)
    @locale = (@feed_target&.language || 'en').to_sym
    I18n.locale = @locale

    # Only be use for single activity request
    @activity = feed['new'].first
    @actor_id = @activity['actor'].split(':').last
  end

  # Find correspond user from feed id
  def feed_target
    User.find_by(id: feed_id)
  end

  # Get the corresponding feed url
  def feed_url
    client_url = 'https://kitsu.io'
    # Direct to user notifications list when more than one action
    return "#{client_url}/notifications" if activities.length > 1

    model_type, model_id = activity['foreign_id'].split(':')
    path = ''
    case model_type
    when 'Follow'
      path = "/users/#{actor_id}"
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
    when 'GroupInvite'
      path = "/group-invite/#{model_id}"
    end

    "#{client_url}#{path}?notification=#{activity['id']}"
  end

  # Express activity of this feed in desired locale
  def stringify_activity
    return Hash[locale, summarize_activities] if activities.length > 1

    actor_name = User.find_by(id: actor_id)&.name

    stringify = case activity['verb']
                when 'follow', 'post', 'post_like', 'comment_like', 'invited'
                  I18n.t(activity['verb'].to_sym,
                    scope: [:notifications],
                    actor: actor_name)
                when 'comment'
                  # Checking what exactly this feed is refering to.
                  # Reply in post, reply in comment, mention in comment,
                  # mention in post, or notification from following post
                  reply_to_user_id = activity['reply_to_user'].split(':').last
                  reply_to_type = activity['reply_to_type']
                  mentions = activity['mentioned_users'] || []

                  if mentions.include?(feed_id.to_i)
                    # got mentioned in a comment
                    I18n.t(:comment_mentioned,
                      scope: [:notifications],
                      actor: actor_name)
                  elsif feed_id == reply_to_user_id
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
                    followed_post_activity(actor_name)
                  end
                end

    Hash[locale, stringify]
  end

  private

  # Summarize multiple activities request
  # @return [String] localized activity summary
  def summarize_activities
    activity_counts = activities.each_with_object(Hash.new(0)) do |act, out|
      out[act['verb']] += 1
    end

    activity_summary = activity_counts.map do |k, v|
      I18n.t(k.to_sym, scope: %i[notifications summary], count: v)
    end

    I18n.t(:sentence,
      scope: %i[notifications summary],
      summary: activity_summary.to_sentence)
  end

  # Stringify comment activity of a followed post
  # @param [String] actor_name the name of activity actor
  # @return [String] localized activity
  def followed_post_activity(actor_name)
    target_post_id = activity['target'].split(':').last
    target_post = Post.find_by(id: target_post_id)
    target_post_author = target_post&.user
    target_post_author_id = target_post_author&.id

    unless target_post
      return I18n.t(:other,
        scope: %i[notifications followed_post],
        actor: actor_name)
    end

    if target_post_author_id == actor_id
      I18n.t(:third_person,
        scope: %i[notifications followed_post],
        actor: actor_name)
    elsif target_post_author_id == feed_id
      I18n.t(:first_person,
        scope: %i[notifications followed_post],
        actor: actor_name)
    else
      I18n.t(:someone,
        scope: %i[notifications followed_post],
        actor: actor_name,
        author: target_post_author.name)
    end
  end
end
