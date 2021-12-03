require 'rails_helper'

RSpec.describe LibraryEntryLog, type: :model do
  it { should belong_to(:linked_account).required }
  it { should validate_presence_of(:action_performed) }
  it { should validate_presence_of(:sync_status) }
end
