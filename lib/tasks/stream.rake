namespace :stream do
  namespace :sync do
    desc 'Synchronize followers to Stream'
    task :follows do
      print 'Following'
      Follow.find_in_batches do |group|
        batches = group.map do |g|
          {
            source: Feed.timeline(g.follower.id),
            target: Feed.user(g.following.id)
          }
        end
        Feed.client.follow_many(batches)
        print '.'
      end
      print "\n"
    end
  end
end
