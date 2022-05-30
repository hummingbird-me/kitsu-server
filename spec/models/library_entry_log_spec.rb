require 'rails_helper'

RSpec.describe LibraryEntryLog, type: :model do
  it { is_expected.to belong_to(:linked_account).required }
  it { is_expected.to validate_presence_of(:action_performed) }
  it { is_expected.to validate_presence_of(:sync_status) }
end
