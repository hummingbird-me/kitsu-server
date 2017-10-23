class GroupUnreadFanoutWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(group_id, source_user_id = nil)
    group = Group.find(group_id)
    source_user = User.find(source_user_id) if source_user_id
    group.update(last_activity_at: Time.now)
    GroupUnreadFanoutService.new(group, source_user).run!
  end
end
