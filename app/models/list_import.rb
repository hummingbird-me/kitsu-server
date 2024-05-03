# frozen_string_literal: true

class ListImport < ApplicationRecord
  include Enumerable
  include WithActivity

  belongs_to :user, optional: false

  enum strategy: { greater: 0, obliterate: 1 }
  enum status: { queued: 0, running: 1, failed: 2, completed: 3, partially_failed: 4 }
  alias_attribute :kind, :type

  validates :strategy, presence: true

  validate :type_is_subclass

  def type_is_subclass
    in_namespace = type.start_with?('ListImport')
    is_descendant = type.safe_constantize <= ListImport
    errors.add(:type, 'must be a ListImport class') unless in_namespace && is_descendant
  end

  def input_file
    nil
  end

  # Apply the ListImport
  def apply
    # Send info to Sentry
    Sentry.set_user(id: user.id, email: user.email, username: user.name)
    Sentry.set_tags(
      input_text: input_text.to_s,
      input_file: input_file&.url
    )

    total = count

    # Last-ditch check for validity
    raise 'Import is invalid' unless valid?(:create)

    yield({ status: :running, total:, progress: 0 })
    Chewy.strategy(:atomic) do
      each_with_index do |(media, data), index|
        next if media.blank?
        # Merge the library entries
        le = LibraryEntry.where(user_id: user.id, media:).first_or_initialize
        le.imported = true
        le = merged_entry(le, data)
        le.save! unless le.status.nil?
        yield({ status: :running, total:, progress: index + 1 })
      rescue StandardError => e
        Sentry.capture_exception(e)
        yield({
          status: :partially_failed,
          error_message: e.message,
          error_trace: e.backtrace.join("\n")
        })
      end
    end
    yield({ status: :completed, total:, progress: total })
  rescue StandardError => e
    Sentry.capture_exception(e)
    yield({
      status: :failed,
      error_message: e.message,
      error_trace: e.backtrace.join("\n")
    })
  end

  # Apply the ListImport while updating the model db every [frequency] times
  def apply!(frequency: 20)
    return unless queued?

    apply do |info|
      # Apply every [frequency] updates unless the status is not :running
      if !%i[running partially_failed].include?(info[:status]) || info[:progress].nil? ||
         (info[:progress] % frequency).zero?
        update info
        yield info if block_given?
      end
    end

    Stat::AnimeCategoryBreakdown.for_user(user).recalculate!
    Stat::AnimeAmountConsumed.for_user(user).recalculate!
    Stat::AnimeActivityHistory.for_user(user).recalculate!
    Stat::MangaCategoryBreakdown.for_user(user).recalculate!
    Stat::MangaAmountConsumed.for_user(user).recalculate!
    Stat::MangaActivityHistory.for_user(user).recalculate!
  end

  def apply_async!(queue: 'now')
    ListImportWorker.set(queue:).perform_async(id) unless running?
  end

  def retry_async!(queue: 'eventually')
    update!(status: :queued)
    ListImportWorker.set(queue:).perform_async(id)
  end

  def merged_entry(entry, data)
    case strategy.to_sym
    when :greater
      # Compare the [completions, progress] tuples and pick the greater
      theirs = [data[:completions] || 0, data[:progress] || 0]
      ours = [entry.reconsume_count || 0, entry.progress || 0]

      # -1 if ours, 1 if theirs
      entry.assign_attributes(data) unless (theirs <=> ours).negative?
    when :obliterate
      entry.assign_attributes(data)
    end

    progress_limit = entry.media.progress_limit || entry.media.default_progress_limit
    entry.progress = [entry.progress, progress_limit].min

    entry
  end

  def stream_activity
    return unless failed? || completed?
    user.notifications.activities.new(
      verb: 'imported',
      kind: self.class.name,
      status:
    )
  end

  before_validation do
    self.input_text = input_text.strip if input_text.present?
  end

  after_commit(on: :create) do
    apply_async!
  end
end
