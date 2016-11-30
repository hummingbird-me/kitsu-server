namespace :counters do
  desc 'Update all counter caches'
  task :fix => :environment do
    CounterCacheResets.posts
    CounterCacheResets.media_user_counts
  end
end
