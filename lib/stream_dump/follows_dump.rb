module StreamDump
  class FollowsDump
    delegate :each_id, to: StreamDump

    def initialize(out:)
      @out = out
    end

    def run
      each_id(User.order(id: :asc), 'User Follows') { |user_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "timeline:#{user_id}",
          data: follows_for(user_id) + groups_for(user_id)
        )
      }.force
    end

    private

    def follows_for(user_id)
      Follow.where(follower: user_id).pluck(:followed_id).map { |uid| "profile:#{uid}" }
    end

    def groups_for(user_id)
      GroupMember.where(user: user_id).pluck(:group_id).map { |gid| "group:#{gid}" }
    end
  end
end
