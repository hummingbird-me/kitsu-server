namespace :counters do
  desc 'Update all counter caches'
  task :fix => :environment do
    CounterCacheResets.posts
  end
end
