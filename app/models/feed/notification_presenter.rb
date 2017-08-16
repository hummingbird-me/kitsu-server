class Feed
  class NotificationPresenter
    CLIENT_URL = 'https://kitsu.io/'.freeze

    attr_reader :activity, :user
    delegate :group, to: :activity

    def initialize(activity, user)
      @activity = activity
      @user = user
    end

    def url
      "#{CLIENT_URL}#{path}?notification=#{activity.id}"
    end

    def message
      actor = actor.name
      actor_two = secondary_actor.name
      count = actors.count - 1

      case verb
      when :follow, :post_like, :comment_like, :invited
        translate(verb, actor: actor, actor_two: actor_two, count: count)
      when :post
        translate('mention.post', actor: actor)
      when :mention
        translate('mention.comment', actor: actor)
      when :reply
        type = activities.first.reply_to_type.underscore
        translate("reply.#{type}", actor: actor, actor_two: actor_two, count: count)
      end
    end

    def verb
      case group.verb
      when :comment
        if activity.mentioned_users.include?(user.id)
          :mention
        else
          :reply
        end
      else
        group.verb
      end
    end

    private

    def path
      case subject.class
      when Post, Comment, GroupInvite then path_for(subject)
      when PostLike, CommentLike then path_for(target)
      when Follow then path_for(actor)
      end
    end

    def path_for(obj)
      type = obj.class.name.underscore.pluralize.dasherize
      id = obj.id
      "#{type}/#{id}"
    end

    def reply_to
      reply_to_user = load_ref(activity.reply_to_user)
      if target.user.id == user.id then %i[you post] # X replied to your post
      elsif reply_to_user.id == user.id then %i[you comment] # X replied to your comment
      elsif target.user.id == actor.id then %i[themself post] # X replied to their own post
      elsif target.is_a?(Post) then %i[author post] # X replied to Y's post
      else %i[unknown post]
      end
    end

    def split_ref(ref)
      refs = ref.split(':')
      { type: refs.first.underscore.to_sym, id: refs.last.to_i }
    end

    def load_ref(ref)
      ref = split_ref(ref)
      ref[:type].constantize.find_by(id: ref[:id])
    end

    def target
      @target ||= load_ref(activity.target)
    end

    def subject
      @subject ||= load_ref(activity.foreign_id)
    end

    def actor
      @actor ||= load_ref(activity.actor)
    end

    def secondary_actor
      @secondary_actor ||= load_ref(group.activities.second.actor)
    end

    def actors
      @actors ||= group.activities.map { |a| split_ref(a.actor) }.uniq
    end

    def translate(*args)
      opts = args.last.is_a?(Hash) ? args.pop.dup : {}
      opts[:scope] ||= %i[notifications]
      I18n.t(*args, opts)
    end
  end
end
