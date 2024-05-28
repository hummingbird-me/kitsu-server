# frozen_string_literal: true

class TimelineStory
  class ProfileTimelineStory < TimelineStory
    self.table_name = 'timeline_profile'
    self.primary_key = %i[user_id story_id]

    belongs_to :user
  end
end
