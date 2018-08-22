module StreamDump
  class PostsDump
    delegate :each_id, to: StreamDump

    def initialize(out:)
      @out = out
    end

    def run
      personal_posts
      wall_posts
      group_posts
      @out
    end

    private

    def personal_posts
      each_id(User.order(id: :asc), 'Personal Posts') { |user_id|
        posts = StreamDump::Post.for_user(user_id).includes(:user, :media, :spoiled_unit)
        next if posts.blank?
        data = posts.find_each.map(&:complete_stream_activity).compact
        next if data.blank?
        @out.puts Oj.dump(
          instruction: 'add_activities',
          feedId: "profile:#{user_id}",
          data: data
        )
      }.force
    end

    def wall_posts
      each_id(User.order(id: :asc), 'Wall Posts') { |user_id|
        posts = StreamDump::Post.for_user_aggr(user_id)
                                .includes(:user, :media, :spoiled_unit, :target_user)
        next if posts.blank?
        data = posts.find_each.map(&:complete_stream_activity).compact
        next if data.blank?
        @out.puts Oj.dump(
          instruction: 'add_activities',
          feedId: "profile_aggr:#{user_id}",
          data: data
        )
      }.force
    end

    def group_posts
      each_id(Group.order(id: :asc), 'Group Posts') { |group_id|
        posts = StreamDump::Post.for_group(group_id).includes(:user, :media, :spoiled_unit, :group)
        next if posts.blank?
        data = posts.find_each.map(&:complete_stream_activity).compact
        next if data.blank?
        @out.puts Oj.dump(
          instruction: 'add_activities',
          feedId: "group:#{group_id}",
          data: data
        )
      }.force
    end
  end
end
