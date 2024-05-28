class UpdateTimelineGlobal < ActiveRecord::Migration[6.1]
  def change
    replace_view :timeline_global, version: 2, revert_to_version: 1
  end
end
