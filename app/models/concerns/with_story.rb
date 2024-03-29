# frozen_string_literal: true

module WithStory
  extend ActiveSupport::Concern

  class_methods do
    def with_story(&)
      belongs_to :story, optional: true, dependent: :destroy

      before_create do
        story = instance_eval(&)
        story.created_at = created_at
        story.save!
        self.story_id = story.id
      end
    end
  end
end
