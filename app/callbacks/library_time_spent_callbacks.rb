# Hooks onto LibraryEntry and manages updating the time_spent column as the progress/reconsume_count
# change over time.
class LibraryTimeSpentCallbacks < Callbacks
  # @param klass [Class] the class to hook the callbacks for
  def self.hook(klass)
    klass.before_save(self)
  end

  def before_save
    return unless record.progress_changed? || record.reconsume_count_changed?
    return unless record.media.respond_to?(:episodes)

    record.time_spent += time_diff
  end

  private

  # @return [Integer] the difference between the new progress and the previous
  def progress_diff
    return 0 unless record.progress_changed?
    record.progress - record.progress_was
  end

  # @return [Integer] the difference between the new reconsume_count and the previous
  def reconsume_diff
    return 0 unless record.reconsume_count_changed?
    record.reconsume_count - record.reconsume_count_was
  end

  # @return [Integer] the time difference caused by the progress change
  def progress_time_diff
    return 0 if progress_diff.zero?
    action, range = if progress_diff.positive?
                      [:+, (record.progress_was...record.progress)]
                    elsif progress_diff.negative?
                      [:-, ((record.progress + 1)..record.progress_was)]
                    end
    # Set the sign
    0.send(action, record.media.episodes.for_range(range).sum(:length))
  end

  # @return [Integer] the time difference caused by the reconsume_count change
  def reconsume_time_diff
    return 0 if reconsume_diff.zero?
    reconsume_diff * record.media.total_length
  end

  # @return [Integer] the time difference from this entire update
  def time_diff
    progress_time_diff + reconsume_time_diff
  end
end
