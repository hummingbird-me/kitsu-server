require 'rails_helper'

RSpec.describe LibraryEvent, type: :model do
  subject { described_class.new }

  it { should belong_to(:library_entry).required }
  it { should belong_to(:user).required }

  it { should validate_presence_of(:kind) }

  it { should define_enum_for(:kind).with_values(%i[progressed updated reacted rated annotated]) }
end
