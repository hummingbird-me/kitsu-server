require_dependency 'with_progress_bar'

class MongoProcessor
  include WithProgressBar

  def initialize(view, batch_size: 1000, in_threads: 4)
    @view = view
    @threads = in_threads
    @batch_size = batch_size
    @enum = @view.batch_size(@batch_size).to_enum
    @queue = Queue.new
  end

  # The grabber is a thread which can be resumed at any time to queue up a new
  def grabber
    @grabber ||= Thread.new do
      loop do
        begin
          @batch_size.times { @queue.push(@enum.next) }
          Thread.stop
        rescue StopIteration
          Thread.exit
        end
      end
    end
  end

  def each(&block)
    bar = progress_bar(@view.collection.name, @view.count)
    Parallel.each(
      ->(*) { grabber.run.alive? ? @queue.pop : Parallel::Stop },
      in_threads: @threads,
      finish: ->(*) { bar.increment },
      &block
    )
    bar.finish
  end
end
