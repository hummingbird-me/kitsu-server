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

require 'rails_helper'

RSpec.describe LibraryEntryLog, type: :model do
  it { should belong_to(:linked_account) }
  it { should validate_presence_of(:action_performed) }
  it { should validate_presence_of(:sync_status) }
end
