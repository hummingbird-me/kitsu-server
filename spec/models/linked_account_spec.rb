require 'rails_helper'

RSpec.describe LinkedAccount, type: :model do
  subject { described_class.new }

  it { should belong_to(:user).required }
  it { should have_many(:library_entry_logs) }
  it { should validate_presence_of(:external_user_id) }
  it { should validate_presence_of(:type) }
end
