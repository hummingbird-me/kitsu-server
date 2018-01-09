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

    diff = LibraryEntryDiff.new(record)
    record.time_spent += diff.time_diff
  end
end
