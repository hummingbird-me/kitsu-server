require 'update_in_batches'

class UpdateSynopsisDescriptionField < ActiveRecord::Migration[5.1]
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    Anime.logger = Logger.new(STDERR)

    %i(anime episodes manga chapters dramas).each do |model_name|
      model = model_name.to_s.classify.constantize
      model.all.update_in_batches(<<-SQL)
        temp_description = json_build_object('en', synopsis)::jsonb
      SQL
    end

    %i(
      amas categories characters community_recommendation_requests
      genres group_categories people site_announcements
    ).each do |model_name|
      model = model_name.to_s.classify.constantize
      model.all.update_in_batches(<<-SQL)
        temp_description = json_build_object('en', description)::jsonb
      SQL
    end
  end
end
