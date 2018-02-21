class ProfileFeed < Feed
  include FanoutOptional
  feed_name 'user'
end
