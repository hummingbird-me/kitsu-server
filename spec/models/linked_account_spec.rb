require 'rails_helper'

RSpec.describe LinkedAccount, type: :model do
  subject { described_class.new }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to have_many(:library_entry_logs) }
  it { is_expected.to validate_presence_of(:external_user_id) }
  it { is_expected.to validate_presence_of(:type) }
end
