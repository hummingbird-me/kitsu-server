# Parse getstream.io webhook reqest
class GetstreamWebhookService
  attr_reader :activity

  def initialize(feed)
    #TODO Experiment will there be multiple activities
    @activity = feed['new'].first
  end

  # Find the activity actor base on the actor id provided
  def actor
    User.find_by(id: activity['actor'].split(':').last.to_i)
  end

  # 
  def activity_targets
    targets = []
    activity['to'].each do |t|
      group, id = t.split(':')
      next unless group == 'notifications'
      user = User.find_by(id: id)
      targets << user if user.present?
    end
    targets
  end

  def stringify_activity(actor, locale='en')
    case activity['verb']
    when 'follow'
      I18n.t(:followed, scope: [:notifications], actor: actor, locale: locale)
    when 'post'
      I18n.t(:followed, scope: [:notifications], actor: actor, locale: locale)
    when 'post_like'
      I18n.t(:followed, scope: [:notifications], actor: actor, locale: locale)
    when 'comment_like'
      I18n.t(:followed, scope: [:notifications], actor: actor, locale: locale)
    when 'comment'
      I18n.t(:followed, scope: [:notifications], actor: actor, locale: locale)
    end
  end
end