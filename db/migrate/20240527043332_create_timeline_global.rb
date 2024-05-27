class CreateTimelineGlobal < ActiveRecord::Migration[6.1]
  def change
    create_view :timeline_global
  end
end
