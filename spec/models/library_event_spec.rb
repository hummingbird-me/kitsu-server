require 'rails_helper'

RSpec.describe LibraryEvent, type: :model do
  subject { described_class.new }

  it { should belong_to(:library_entry) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:library_entry) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:event) }

  it { should define_enum_for(:event).with(%i[added updated]) }
  it { should define_enum_for(:status).with(LibraryEntry.statuses) }
end
