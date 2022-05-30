require 'rails_helper'

RSpec.describe UserIpAddress, type: :model do
  subject { build(:user_ip_address) }

  it { is_expected.to belong_to(:user).required }
end
