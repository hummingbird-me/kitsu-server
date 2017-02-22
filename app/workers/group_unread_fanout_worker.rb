class GroupUnreadFanoutWorker
  include Sidekiq::Worker

  def perform(group_id)
    group = Group.find(group_id)
    GroupUnreadFanoutService.new(group).run!
  end
end
