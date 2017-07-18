class MediaFeed < Feed
  include MediaUpdatesFilterable
  include FanoutOptional
end
