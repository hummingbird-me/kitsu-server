module MaintainVisitedAt
  extend ActiveSupport::Concern

  def maintain_visited_at
    current_user.resource_owner.update_visited_at! if signed_in?
  end

  included do
    before_action :maintain_visited_at
  end
end
