# frozen_string_literal: true

module WithStory
  extend ActiveSupport::Concern

  class_methods do
    def with_story(&)
      belongs_to :story, optional: true, dependent: :destroy

      after_update do
        story_data = instance_eval(&).data
        story.update!(data: story_data) if story_data != story.data
      end

      after_create do
        story = instance_eval(&)
        story.created_at = created_at
        story.save!
        update_attribute(:story_id, story.id)
      end
    end
  end
end
