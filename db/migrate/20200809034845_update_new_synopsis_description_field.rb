class UpdateNewSynopsisDescriptionField < ActiveRecord::Migration[5.1]
  def change
    Anime.logger = Logger.new(STDERR)

    %i(anime episodes manga chapters dramas).each do |model_name|
      remove_column model_name, :synopsis
      rename_column model_name, :temp_description, :description
    end

    %i(
      amas categories characters community_recommendation_requests
      genres group_categories people site_announcements
    ).each do |model_name|
      remove_column model_name, :description
      rename_column model_name, :temp_description, :description
    end
  end
end
