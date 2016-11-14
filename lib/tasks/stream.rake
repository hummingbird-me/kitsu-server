namespace :stream do
  namespace :sync do
    desc 'Synchronize followers to Stream'
    task :follows => :environment do
      StreamSync.follows
    end

    desc 'Synchronize automatic (under-the-hood) follows to Stream'
    task :auto_follows => :environment do
      StreamSync.follow_timeline
      StreamSync.follow_global
      StreamSync.follow_user_aggr

      [Anime, Manga, Drama].each do |type|
        StreamSync.follow_media_aggr(type)
      end
    end
  end

  namespace :dump do
    desc 'Dump posts in the mass import format for Stream'
    task :posts => :environment do
      StreamDump.posts.each { |instr| puts instr.to_json }
    end

    desc 'Dump all stories in the mass import format for Stream'
    task :stories => :environment do
      StreamDump.stories.each { |instr| STDOUT.puts instr.to_json }
    end
  end
end
