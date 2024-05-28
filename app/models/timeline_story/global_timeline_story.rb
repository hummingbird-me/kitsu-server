# frozen_string_literal: true

class TimelineStory
  class GlobalTimelineStory < TimelineStory
    self.table_name = 'timeline_global'
    self.primary_key = %i[story_id]
  end
end
