namespace :stream do
  namespace :sync do
    desc 'Synchronize followers to Stream'
    task :follows => :environment do
      StreamSync.sync_follows
    end

    desc 'Synchronize automatic (under-the-hood) follows to Stream'
    task :auto_follows => :environment do
      StreamSync.follow_user_aggr

      [Anime, Manga, Drama].each do |type|
        StreamSync.follow_media_aggr(type)
      end
    end
  end
end
