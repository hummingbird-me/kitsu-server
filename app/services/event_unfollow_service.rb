module EventUnfollowService
  KEY = 'EventUnfollowService:previous_id'.freeze

  module_function

  def unfollow_next
    EventFollowService.new(next_event).unfollow
    self.previous_id = next_event.id
  end

  def next_event
    @next_event ||= LibraryEvent.unfollowed.where('id > ?', previous_id).order(id: :asc).first
  end

  def previous_id
    $redis.with { |conn| conn.get(KEY) } || default_previous_id
  end

  def previous_id=(val)
    $redis.with { |conn| conn.set(KEY, val) }
  end

  def default_previous_id
    LibraryEvent.unfollowed.order(id: :desc).offset(1200).limit(1).ids.first
  end
end
