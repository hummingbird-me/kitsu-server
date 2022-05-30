require 'rails_helper'

RSpec.describe MediaIgnore, type: :model do
  it { is_expected.to validate_presence_of(:media).with_message('must exist') }
  it { is_expected.to validate_presence_of(:user).with_message('must exist') }
end
