# frozen_string_literal: true

# A Feed is a flat, reverse-chronological list of Stories. They are not intended to be exposed to
# clients directly, but are instead used as targets for following. They are primarily a foreign key
# connecting a set of FeedStories to a User, Group, Unit, Media, or other object.
#
# This is named NewFeed because the original Feed class is used for legacy GetStream-backed feeds.
# Once those are removed, this will be renamed to Feed.
class NewFeed < ApplicationRecord
  self.table_name = 'feeds'

  has_many :stories, class_name: 'FeedStory', foreign_key: 'feed_id', inverse_of: :feed,
    dependent: :delete_all
end
