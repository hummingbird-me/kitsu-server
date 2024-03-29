# frozen_string_literal: true

class FeedStory < ApplicationRecord
  belongs_to :story, inverse_of: :feed_stories
  belongs_to :feed, class_name: 'NewFeed', inverse_of: :stories
end
