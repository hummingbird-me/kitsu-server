class CreateTimelineFollowing < ActiveRecord::Migration[6.1]
  def change
    create_view :timeline_following
  end
end
