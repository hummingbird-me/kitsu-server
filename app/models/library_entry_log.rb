# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: library_entry_logs
#
#  id                :integer          not null, primary key
#  action_performed  :string           default("create"), not null
#  error_message     :text
#  media_type        :string           not null
#  progress          :integer
#  rating            :integer
#  reconsume_count   :integer
#  reconsuming       :boolean
#  status            :integer
#  sync_status       :integer          default(0), not null
#  volumes_owned     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  linked_account_id :integer          not null, indexed
#  media_id          :integer          not null
#
# Indexes
#
#  index_library_entry_logs_on_linked_account_id  (linked_account_id)
#
# rubocop:enable Metrics/LineLength

class LibraryEntryLog < ApplicationRecord
  belongs_to :linked_account, required: true
  belongs_to :media, polymorphic: true, required: true

  enum sync_status: %i[pending success error]
  enum status: LibraryEntry.statuses

  validates_presence_of :action_performed, :sync_status

  def self.create_for(method, library_entry, linked_account_id)
    LibraryEntryLog.create!(
      media_type: library_entry.media_type,
      media_id: library_entry.media_id,
      progress: library_entry.progress,
      rating: library_entry.rating,
      reconsume_count: library_entry.reconsume_count,
      reconsuming: library_entry.reconsuming,
      status: library_entry.status,
      volumes_owned: library_entry.volumes_owned,
      # action_performed is either create, update, destroy
      action_performed: method,
      linked_account: linked_account_id
    )
  end

  # Returns a scope of records matching a provided library entry
  def self.for_entry(library_entry)
    where(
      media_type: library_entry.media_type,
      media_id: library_entry.media_id
    )
  end
end
