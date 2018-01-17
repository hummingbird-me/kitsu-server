require_dependency 'with_progress_bar'

class MongoProcessor
  include WithProgressBar

  def initialize(view, batch_size: 5000, in_threads: 20)
    @view = view
    @threads = in_threads
    @batch_size = batch_size
    @min_queue_size = @batch_size * 0.05
    @enum = @view.respond_to?(:batch_size) ? @view.batch_size(batch_size).to_enum : @view.to_enum
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
          @queue.close
          Thread.exit
        end
      end
    end
  end

  def refill_queue
    return unless grabber.alive?
    grabber.run if @queue.length < @min_queue_size
  end

  def next(*)
    @queue.pop.tap { refill_queue }
  rescue ClosedQueueError
    Parallel::Stop
  end

  def each(&block)
    view = @view.respond_to?(:view) ? @view.view : @view
    bar = progress_bar(view.collection.name, view.count)
    refill_queue
    Parallel.each(
      method(:next),
      in_threads: @threads,
      finish: ->(*) { bar.increment },
      &block
    )
    bar.finish
  end

  def next_batch(*)
    Array.new(@batch_size) { @queue.pop }.tap { refill_queue }
  rescue ClosedQueueError
    Parallel::Stop
  end

  def each_batch(&block)
    refill_queue
    Parallel.each(
      method(:next_batch),
      in_threads: @threads,
      &block
    )
  end
end
