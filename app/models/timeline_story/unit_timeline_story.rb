# frozen_string_literal: true

class TimelineStory
  class UnitTimelineStory < TimelineStory
    self.table_name = 'timeline_units'
    self.primary_key = %i[unit_type unit_id story_id]

    belongs_to :unit, polymorphic: true
  end
end
