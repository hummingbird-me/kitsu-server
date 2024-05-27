class CreateTimelineUnits < ActiveRecord::Migration[6.1]
  def change
    create_view :timeline_units
  end
end
