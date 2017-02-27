# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

class ListImport < ApplicationRecord
  has_paper_trail
  include Enumerable
  include WithActivity

  belongs_to :user, required: true, touch: true

  enum strategy: %i[greater obliterate]
  enum status: %i[queued running failed completed]
  has_attached_file :input_file, s3_permissions: :private
  alias_attribute :kind, :type

  validates :strategy, presence: true
  validates :input_text, presence: { unless: :input_file? }
  validates_attachment :input_file, presence: { unless: :input_text? }
  validates_attachment :input_file, content_type: { content_type: %w[] }

  validate :type_is_subclass

  def type_is_subclass
    in_namespace = type.start_with?('ListImport')
    is_descendant = type.safe_constantize <= ListImport
    unless in_namespace && is_descendant
      errors.add(:type, 'must be a ListImport class')
    end
  end

  # Apply the ListImport
  def apply
    raise 'No each method defined' unless respond_to? :each

    # Send info to Sentry
    Raven.user_context(id: user.id, email: user.email, username: user.name)
    Raven.extra_context(
      input_text: input_text.to_s,
      input_file: input_file.to_s
    )

    # Last-ditch check for validity
    raise 'Import is invalid' unless valid?(:create)

    yield({ status: :running, total: count, progress: 0 })
    LibraryEntry.transaction do
      each_with_index do |(media, data), index|
        next unless media.present?
        # Cap the progress
        limit = media.progress_limit || media.default_progress_limit
        data[:progress] = [data[:progress], limit].compact.min
        # Merge the library entries
        le = LibraryEntry.where(user: user, media: media).first_or_initialize
        le.imported = true
        le = merged_entry(le, data)
        le.save! unless le.status == nil
        yield({ status: :running, total: count, progress: index + 1 })
      end
    end
    yield({ status: :completed, total: count, progress: count })
  rescue StandardError => e
    Raven.capture_exception(e)
    yield({
      status: :failed,
      total: count,
      error_message: e.message,
      error_trace: e.backtrace.join("\n")
    })
  end

  # Apply the ListImport while updating the model db every [frequency] times
  def apply!(frequency: 20)
    apply do |info|
      # Apply every [frequency] updates unless the status is not :running
      if info[:status] != :running || (info[:progress] % frequency).zero?
        update info
        yield info if block_given?
      end
    end
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
    entry
  end

  def stream_activity
    if failed? || completed?
      user.notifications.activities.new(
        verb: 'imported',
        kind: self.class.name,
        status: status
      )
    end
  end

  after_create do
    ListImportWorker.perform_async(id)
  end
end
