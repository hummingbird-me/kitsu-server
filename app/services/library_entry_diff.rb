# frozen_string_literal: true

class LibraryEntryDiff
  # @param entry [LibraryEntry] the library entry to give difference methods on
  def initialize(entry)
    @entry = entry
  end

  # @return [Integer] the difference between the new progress and the previous
  def progress_diff
    return 0 unless @entry.progress_changed?

    @entry.progress - (@entry.progress_was || 0)
  end

  # @return [Integer] the difference between the new reconsume_count and the previous
  def reconsume_diff
    return 0 unless @entry.reconsume_count_changed?

    @entry.reconsume_count - (@entry.reconsume_count_was || 0)
  end

  # @return [Integer] the time difference from this entire update
  def time_diff
    progress_time_diff + reconsume_time_diff
  end

  # @return [Boolean] whether the entry has moved from completed to not
  def became_uncompleted?
    return false unless @entry.status_was == 'completed' || @entry.reconsume_count_was&.positive?
    return true unless @entry.status == 'completed' || @entry.reconsume_count&.positive?
  end

  # @return [Boolean] whether the entry has moved to completed
  def became_completed?
    return false if @entry.status_was == 'completed' || @entry.reconsume_count_was&.positive?
    return true if @entry.status == 'completed' || @entry.reconsume_count&.positive?
  end

  private

  # @return [Integer] the time difference caused by the progress change
  def progress_time_diff
    return 0 if progress_diff.zero? || !@entry.media.respond_to?(:episodes)

    progress_was = @entry.progress_was || 0
    action, range = if progress_diff.positive?
      [:+, ((progress_was + 1)..@entry.progress)]
    elsif progress_diff.negative?
      [:-, ((@entry.progress + 1)..@entry.progress_was)]
    end
    # Set the sign
    0.send(action, @entry.media.episodes.for_range(range).sum(:length))
  end

  # @return [Integer] the time difference caused by the reconsume_count change
  def reconsume_time_diff
    return 0 if reconsume_diff.zero? || !@entry.media.respond_to?(:episodes)

    reconsume_diff * (@entry.media.total_length || 0)
  end
end
