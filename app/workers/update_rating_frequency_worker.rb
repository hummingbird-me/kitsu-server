class UpdateRatingFrequencyWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(klass_name, klass_id, rating, diff)
    update_query = <<-EOF
      rating_frequencies = rating_frequencies
        || hstore('#{rating}', (
          COALESCE(rating_frequencies->'#{rating}', '0')::integer + #{diff}
        )::text)
    EOF
    klass = klass_name.safe_constantize
    klass_obj = klass.find(klass_id)
    klass.where(id: klass_id).update_all(update_query)
    klass_obj.touch
  end
end
