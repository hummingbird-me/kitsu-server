class ProfileFeed < Feed
  include MediaUpdatesFilterable
  include FanoutOptional
  feed_name 'user'
end
