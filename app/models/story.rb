# frozen_string_literal: true

class Story < ApplicationRecord
  enum type: {
    'Story::PostStory' => 1,
    'Story::FollowStory' => 2,
    'Story::MediaReactionStory' => 3
  }

  has_many :feed_stories, inverse_of: :story, dependent: :delete_all

  def bump!(time = Time.now)
    # We know what we're doing here, so we can skip validations.
    # rubocop:disable Rails/SkipsModelValidations
    update_column(:bumped_at, time)
    # Don't ever unbump something during update.
    feed_stories.in_batches.update_all(['bumped_at = greatest(bumped_at, ?)', time])
    # rubocop:enable Rails/SkipsModelValidations
  end

  before_create do
    self.bumped_at = created_at
  end
end
