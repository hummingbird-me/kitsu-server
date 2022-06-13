class DematerializeMediaCastings < ActiveRecord::Migration[6.1]
  def change
    drop_view :media_castings, materialized: true
    create_view :media_castings
  end
end
