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
  include Enumerable
  include WithActivity

  belongs_to :user, required: true, touch: true

  enum strategy: %i[greater obliterate]
  enum status: %i[queued running failed completed]
  has_attached_file :input_file, s3_permissions: :private

  validates :strategy, presence: true
  validates :input_text, presence: { unless: :input_file? }
  validates_attachment :input_file, presence: { unless: :input_text? }
  validates_attachment :input_file, content_type: { content_type: %w[] }

  # Apply the ListImport
  def apply
    fail 'No each method defined' unless respond_to? :each

    yield({ status: :running, total: count, current: 0 })
    LibraryEntry.transaction do
      each_with_index do |(media, data), index|
        entry = LibraryEntry.where(user: user, media: media).first_or_create
        merged_entry(entry, data).save!
        yield({ status: :running, total: count, current: index + 1 })
      end
    end
    yield({ status: :completed, total: count, current: count })
  rescue StandardError => e
    yield({
      status: :error,
      total: count,
      error_message: e.message,
      error_trace: e.backtrace.join("\n")
    })
  end

  # Apply the ListImport while updating the model db every [frequency] times
  def apply!(frequency: 20)
    apply do |info|
      # Apply every [frequency] updates unless the status is not :running
      if info[:status] != :running || info[:current] % frequency == 0
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
      entry.assign_attributes(data) if (theirs <=> ours).positive?
    when :obliterate
      entry.assign_attributes(data)
    end
    entry
  end

  def stream_activity
    user.notifications.activities.new(status: status) if failed? || completed?
  end

  after_create do
    ListImportWorker.perform_async(id)
  end
end
