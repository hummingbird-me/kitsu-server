class GroupUnreadFanoutWorker
  include Sidekiq::Worker

  def perform(group_id)
    group = Group.find(group_id)
    group.update(last_activity_at: Time.now)
    GroupUnreadFanoutService.new(group).run!
  end
end
