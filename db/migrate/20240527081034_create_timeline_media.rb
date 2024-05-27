class CreateTimelineMedia < ActiveRecord::Migration[6.1]
  def change
    create_view :timeline_media
  end
end
