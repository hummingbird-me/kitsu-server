# frozen_string_literal: true

class Story < ApplicationRecord
  enum type: {
    'Story::PostStory' => 1,
    follow: 2,
    media_reaction: 3
  }

  has_many :feed_stories, inverse_of: :story, dependent: :delete_all

  before_create do
    self.bumped_at = created_at
  end
end
