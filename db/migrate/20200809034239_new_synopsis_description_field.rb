class NewSynopsisDescriptionField < ActiveRecord::Migration[5.1]
  def change
    Anime.logger = Logger.new(STDERR)

    %i(anime episodes manga chapters dramas).each do |model_name|
      add_column model_name, :temp_description, :jsonb, default: {}, null: false
    end

    %i(
      amas categories characters community_recommendation_requests
      genres group_categories people site_announcements
    ).each do |model_name|
      add_column model_name, :temp_description, :jsonb, default: {}, null: false
    end
  end
end
