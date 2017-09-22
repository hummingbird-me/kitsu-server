class StreamJournal
  class JournaledFeed
    # @private
    # @param group [String,#to_s] the feed group
    # @param id [String,#to_s] the feed id
    # @param journal [StreamJournal] the journal to write to
    def initialize(group, id, journal)
      @group = group
      @id = id
      @journal = journal
    end

    # @api getstream-compat
    # @param act [Hash] the activity object
    # @return [Hash] a hash with the execution duration
    def add_activity(act)
      @journal.write(feed: feed, action: 'add_activity', activity: act.as_json)
    end

    # @api getstream-compat
    # @param id [String,#to_s] the ID to delete
    # @param foreign_id [Boolean] whether the ID is a foreign_id or not
    # @return [Hash] a hash with the execution duration
    def remove_activity(id, foreign_id: false)
      @journal.write(feed: feed, action: 'remove_activity', id: id, foreign_id: foreign_id)
    end

    # @api getstream-compat
    # @param group [String,#to_s] the feed group
    # @param id [String,#to_s] the feed id
    # @return [Hash] a hash with the execution duration
    def unfollow(group, id, keep_history: false)
      target = "#{group}:#{id}"
      @journal.write(feed: feed, action: 'unfollow', target: target, keep_history: keep_history)
    end

    # @api getstream-compat
    # @param group [String,#to_s] the feed group
    # @param id [String,#to_s] the feed id
    # @return [Hash] a hash with the execution duration
    def follow(group, id, *)
      target = "#{group}:#{id}"
      @journal.write(feed: feed, action: 'follow', target: target)
    end

    # @api getstream-compat
    # @raise [NotImplementedError]
    def readonly_token(*)
      raise NotImplementedError
    end

    # @api getstream-compat
    # @raise [NotImplementedError]
    def get(*)
      raise NotImplementedError
    end
  end
end
