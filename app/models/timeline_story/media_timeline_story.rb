# frozen_string_literal: true

class TimelineStory
  class MediaTimelineStory < TimelineStory
    self.table_name = 'timeline_media'
    self.primary_key = %i[media_type media_id story_id]

    belongs_to :media, polymorphic: true
  end
end
