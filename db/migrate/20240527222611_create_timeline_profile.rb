class CreateTimelineProfile < ActiveRecord::Migration[6.1]
  def change
    create_view :timeline_profile
  end
end
