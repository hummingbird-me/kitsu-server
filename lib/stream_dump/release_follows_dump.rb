module StreamDump
  class ReleaseFollowsDump
    delegate :each_id, to: StreamDump

    def initialize(out:)
      @out = out
    end

    def run
      each_id(User.order(id: :asc), 'User Follows') { |user_id|
        entries = LibraryEntry.where(user: user_id, status: [1, 2]).joins(kind)
                              .where.not("#{kind}.end_date < ?", Date.today)
        feeds = entries.pluck(:media_type, "#{kind}_id").map do |(type, id)|
          "media_releases:#{type}-#{id}"
        end

        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "notifications:#{user_id}",
          data: feeds
        )
      }.force
    end
  end
end
