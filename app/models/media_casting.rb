class MediaCasting < ApplicationRecord
  self.primary_key = :id

  belongs_to :media, polymorphic: true
  belongs_to :character, optional: true
  belongs_to :person, optional: true

  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true)
  end
end
