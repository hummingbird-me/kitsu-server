require_dependency 'postgres_sequence_fixer'

class PostgresSequenceWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'eventually'

  def perform
    PostgresSequenceFixer.run
  end
end
