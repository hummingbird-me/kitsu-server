namespace :counters do
  desc 'Update all counter caches'
  task :fix => :environment do
    CounterCacheResets.posts
    CounterCacheResets.media_user_counts
    CounterCacheResets.reviews
    CounterCacheResets.users
    CounterCacheResets.groups
    CounterCacheResets.category_counts
  end
end
