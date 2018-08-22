module StreamDump
  class AutoFollowsDump
    delegate :each_id, to: StreamDump

    def initialize(out:)
      @out = out
    end

    def run
      groups
      users
      anime
      manga
      episodes
      chapters
      site_announcements
    end

    def groups
      each_id(Group.order(id: :asc), 'Groups') { |group_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "group_aggr:#{group_id}",
          data: ["group:#{group_id}"]
        )
      }.force
    end

    def users
      each_id(User.order(id: :asc), 'Users') { |user_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "timeline:#{user_id}",
          data: ["user:#{user_id}"]
        )
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "user_aggr:#{user_id}",
          data: ["user:#{user_id}"]
        )
      }.force
    end

    def anime
      each_id(Anime.order(id: :asc), 'Anime') { |anime_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "media_aggr:Anime-#{anime_id}",
          data: ["media:Anime-#{anime_id}"]
        )
      }.force
    end

    def manga
      each_id(Manga.order(id: :asc), 'Manga') { |manga_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "media_aggr:Manga-#{manga_id}",
          data: ["media:Manga-#{manga_id}"]
        )
      }.force
    end

    def episodes
      each_id(Episode.order(id: :asc), 'Episodes') { |episode_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "unit_aggr:Episode-#{episode_id}",
          data: ["unit:Episode-#{episode_id}"]
        )
      }.force
    end

    def chapters
      each_id(Chapter.order(id: :asc), 'Chapters') { |chapter_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "unit_aggr:Chapter-#{chapter_id}",
          data: ["unit:Chapter-#{chapter_id}"]
        )
      }.force
    end

    def site_announcements
      each_id(User.order(id: :asc), 'Site Announcements') { |user_id|
        @out.puts Oj.dump(
          instruction: 'follow',
          feedId: "site_announcements:#{user_id}",
          data: %w[site_announcements_global:global]
        )
      }.force
    end
  end
end
