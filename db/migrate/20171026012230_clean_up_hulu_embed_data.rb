class CleanUpHuluEmbedData < ActiveRecord::Migration
  class Video < ActiveRecord::Base; end
  class Streamer < ActiveRecord::Base; end

  def up
    hulu = Streamer.where(site_name: 'Hulu').pluck(:id)
    say_with_time 'Cleaning up Hulu embed_data' do
      Video.where(streamer_id: hulu).update_all(<<-SQL.squish)
        embed_data = json_build_object(
          'eid',
          substring(embed_data->>'embed_url' from '.*eid=(.*)')
        )::jsonb
      SQL
    end
  end
end
