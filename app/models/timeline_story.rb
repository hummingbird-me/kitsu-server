# frozen_string_literal: true

class TimelineStory < ApplicationRecord
  belongs_to :story

  default_scope { order(bumped_at: :desc) }

  def readonly?
    true
  end
end
