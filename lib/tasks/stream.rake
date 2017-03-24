require 'stream_sync'

namespace :stream do
  namespace :sync do
    desc 'Synchronize followers to Stream'
    task follows: :environment do
      StreamSync.follows
    end

    desc 'Synchronize automatic (under-the-hood) follows to Stream'
    task auto_follows: :environment do
      StreamSync.follow_timeline
      StreamSync.follow_global
      StreamSync.follow_user_aggr

      [Anime, Manga, Drama].each do |type|
        StreamSync.follow_media_aggr(type)
      end
    end

    desc 'Synchronize media genres'
    task media_genres: :environment do
      StreamSync.media_genres
    end
  end

  namespace :dump do
    desc 'Dump posts in the mass import format for Stream'
    task posts: :environment do
      StreamDump.posts.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump all stories in the mass import format for Stream'
    task stories: :environment do
      StreamDump.stories.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump automatic follows'
    task auto_follows: :environment do
      StreamDump.auto_follows.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump follows'
    task follows: :environment do
      StreamDump.follows.each { |instr| STDOUT.puts instr.to_json }
    end

    desc 'Dump group stuff'
    task groups: :environment do
      ApplicationRecord.logger = Logger.new(nil)
      StreamDump.group_posts.each { |instr| STDOUT.puts instr.to_json }
      StreamDump.group_memberships.each { |instr| STDOUT.puts instr.to_json }
      StreamDump.group_auto_follows.each { |instr| STDOUT.puts instr.to_json }
    end
  end
end
