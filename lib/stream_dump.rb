class StreamDump
  module_function

  def posts
   User.pluck(:id).map do |user_id|
     posts = Post.where(user_id: user_id)
     next if posts.blank?
     {
       instruction: 'add_activities',
       feedId: Feed.user(user_id).stream_id,
       data: posts.find_each.map(&:complete_stream_activity)
     }
    end
  end
end
