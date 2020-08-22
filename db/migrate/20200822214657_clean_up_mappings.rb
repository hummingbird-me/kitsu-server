class CleanUpMappings < ActiveRecord::Migration[5.1]
  MAPPINGS = %w(anilist kitsu/genres myanimelist/genres/anime myanimelist/person)

  def change
    Mapping.where(external_site: MAPPINGS).delete_all
  end
end
