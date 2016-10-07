class FakeStream
  class Feed
    attr_accessor :fake_group, :fake_feed, :fake_activities, :group, :id

    def initialize(group, id)
      @group = group
      @id = id
      @fake_group = FakeStream.feeds[group]
      @fake_feed = fake_group[:data][id]
      @fake_activities = fake_feed[:activities]
    end

    def get(query)
      { duration: '20ms', results: fake_activities }
    end

    def add_activity(activity)
      fake_activities << activity
      activity.merge(duration: '35ms', id: SecureRandom.uuid).stringify_keys
    end

    def add_activities(activities)
      activities.map { |a| add_activity(a) }
    end

    def remove_activity(id, foreign_id = false)
      key = foreign_id ? :foreign_id : :id
      fake_activities.reject! { |a| a[key] = id }
      {
        duration: '35ms',
        removed: id
      }.stringify_keys
    end

    def follow(group, id)
      target = Feed.new(group, id)
      target.fake_feed[:followers] << feed_id
      fake_feed[:following] << target.feed_id
      { duration: '35ms' }.stringify_keys
    end

    def unfollow(group, id)
      target = Feed.new(group, id)
      target.fake_feed[:followers].reject! { |f| f == feed_id }
      fake_feed[:following].reject! { |f| f == target.feed_id }
      { duration: '35ms' }.stringify_keys
    end

    def followers
      results = fake_feed[:followers].map { |f| follow_result(feed_id, f) }
      { duration: '35ms', results: results }.stringify_keys
    end

    def feed_id
      "#{group}:#{id}"
    end

    private

    def follow_result(feed_id, target_id)
      {
        created_at: Time.now.iso8601,
        updated_at: Time.now.iso8601,
        feed_id: feed_id,
        target_id: target_id
      }.stringify_keys
    end
  end
end
