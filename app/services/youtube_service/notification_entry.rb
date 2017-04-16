class YoutubeService
  class NotificationEntry
    attr_reader :entry

    def initialize(entry)
      @entry = entry.is_a?(String) ? Nokogiri::XML.fragment(entry) : entry
    end

    def channel_id
      entry.at_xpath('./yt:channelId').text
    end

    def video_id
      entry.at_xpath('./yt:videoId').text
    end

    def link
      entry.at_xpath("./xmlns:link[@rel='alternate']")['href']
    end

    def post!(user)
      post = Post.where('content LIKE ?', content_like).where(user: user)
      post.first_or_create!(content: post_content)
    end

    def post_content
      <<-CONTENT.strip
        <!--youtube_video_id=#{video_id} // DO NOT PUT ANYTHING BEFORE THIS-->
        #{link}
      CONTENT
    end

    def content_like
      "<!--youtube_video_id=#{video_id}%"
    end
  end
end
