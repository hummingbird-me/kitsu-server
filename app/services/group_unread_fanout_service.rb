class GroupUnreadFanoutService
  using UpdateInBatches

  attr_reader :group

  def initialize(group)
    @group = group
  end

  def run!
    group.members.update_in_batches('unread_count = unread_count + 1', of: 100)
  end
end
