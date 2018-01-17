module Zorro
  class Wrapper
    # An abstract class for wrapping common parts of posts from Aozora
    class BasePost < Wrapper
      # @return [String] the content for the post
      def content
        content = ''
        content << @data['content']
        content << "\n[spoiler]#{@data['spoilerContent']}[/spoiler]" if @data['hasSpoilers']
        content
      end

      # Wraps the embed properties on a text post from Aozora, providing a fallback order from
      # Youtube/Images/Uploads to Links.  Giphy search (and Image search) hotlinks to an images
      # attribute, uploads get saved in an image attribute (and referenced in the images attribute),
      # and Youtube and Links are in their own little properties.
      #
      # Normally, this would be super easy, but it turns out there's a bit of, uh, overlap between
      # these properties, so we have to exactly match the precedence that Aozora uses in display, so
      # that all data migrates correctly.  With a bit of research, I've found that:
      #
      # youtubeID and hotlink are mutually exclusive
      # youtubeID and upload (2 Threads, 3 TimelinePosts) -- Youtube wins
      # youtubeID and link (11 Threads, 3 Posts, 13 TimelinePosts) -- Youtube wins
      # upload and link (69 Threads, 2 Posts, 53 TimelinePosts) -- upload wins
      # upload and hotlink (13 Threads, 5 Posts, 108 TimelinePosts) -- hotlink wins
      #
      # This gives us the following order:
      #   Youtube > Hotlinked Images > Upload > Link
      #
      # @return [Hash, nil] the embed data, if found
      def embed
        if youtube_url then youtube_embed
        # Uploads don't get put in the embed field on Kitsu
        elsif upload_url then nil
        elsif image then image_embed
        elsif link then link
        end
      end

      # We store an edit time, they store an edit flag.  Use updated_at to fake an edited timestamp
      #
      # @return [Time, nil] the estimated edit time, if edited
      def edited_at
        updated_at if @data['edited']
      end

      # @return [User] the user who created this post
      def user
        User.find_by(ao_id: @data['_p_postedBy'])
      end

      # @return [Hash] the attributes to save to our database
      def to_h
        {
          ao_id: id,
          content: content,
          edited_at: edited_at,
          updated_at: updated_at,
          created_at: created_at,
          user: user
        }
      end

      # @return [Boolean] whether to save to our database
      def save?
        true
      end

      # Create the post in our database
      # @return [Post,nil] the post that was created
      def save!
        Post.create!(to_h) if save?
      end

      private

      # The YoutubeID wrapped into a full Youtube URL
      # @return [String] the Youtube URL
      def youtube_url
        "https://www.youtube.com/watch?v=#{@data['youtubeID']}" if @data['youtubeID']
      end

      # The embed data for the Youtube link
      # @return [String] the Youtube embed JSON data
      def youtube_embed
        EmbedService.new(youtube_url).to_json
      end

      # The URL for the uploaded file, if the upload is displayed
      # @return [String, nil] the URL of the file, if displayed
      def upload_url
        return unless @data['image']
        # Isn't actually displayed in-app without this set
        return unless image['property'] == 'image'
        file(@data['image'])
      end

      # The images array is... always sized 0 or 1, which means we can just use the first
      # @return [Hash, nil] the image data
      def image
        @data['images']&.first
      end

      # The image data, wrapped so we can put it in the embed attribute
      # @return [Hash, nil] the embed data for the image
      def image_embed
        return unless image
        {
          kind: 'image',
          title: image['url'],
          image: image
        }
      end

      # The link data, restructured to match our own embed JSON
      # @return [Hash, nil] the embed data for the link
      def link
        return unless @data['link']
        link = @data['link']
        # Aozora has embed data, we just need to restructure it a bit
        @link ||= {
          kind: link['type'],
          title: link['title'],
          description: link['description'],
          url: link['url'],
          site_name: link['siteName'],
          image: link['images'].first
        }
      end
    end
  end
end
