require 'rails_helper'

RSpec.describe LibraryEvent, type: :model do
  subject { build(:library_event) }

  it { should belong_to(:library_entry) }
  it { should validate_presence_of(:event) }

  it { should define_enum_for(:event).with(%i[added updated]) }
  it { should define_enum_for(:status).with(LibraryEntry.statuses) }

  # context 'with event=changed' do
  #   subject { build(:library_event, event: :updated) }
  #   it { should validate_presence_of(:status) }
  # end
end
