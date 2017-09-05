module Zorro
  class Wrapper
    class Post < Wrapper
      # Figure out which subclass to delegate to
      def self.wrap(data)
        case data['parentClass']
        when 'Anime' then Zorro::Wrapper::MediaPost.new(data)
        when 'Episode' then Zorro::Wrapper::EpisodePost.new(data)
        when 'Recommendation' then nil
        else
          if data['parentPost'].nil?
            Zorro::Wrapper::PostPost.new(data)
          else
            Zorro::Wrapper::CommentPost.new(data)
          end
        end
      end

      def initialize(data)
        @data = data
      end

      def content
        content = ''
        content << "**#{thread['title']}:**\n\n" if @thread['title']
        content << @data['content']
        content
      end

      def edited_at
        updated_at if @data['edited']
      end

      def thread
        @thread ||= assoc(@data['_p_thread']) || {}
      end

      def target_group
        Zorro::Groups.by_name(thread['subType']) if thread['subType'].present?
      end

      def spoiler
        @data['hasSpoilers']
      end

      def user
        User.find_by(ao_id: @data['_p_postedBy'])
      end

      def to_h
        {
          content: content,
          edited_at: edited_at,
          updated_at: updated_at,
          created_at: created_at,
          spoiler: spoiler,
          target_group: target_group,
          target_user: target_user,
          user: user
        }
      end

      def save!
        Post.create!(to_h)
      end
    end
  end
end
