class UserContentReparentWorker
  include Sidekiq::Worker

  def perform(source_id, target_id)
    Post.where(user_id: source_id).update_all(user_id: target_id)
    Comment.where(user_id: source_id).update_all(user_id: target_id)
    PostLike.where(user_id: source_id).update_all(user_id: target_id)
    CommentLike.where(user_id: source_id).update_all(user_id: target_id)
  end
end
