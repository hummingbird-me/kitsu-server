require 'rails_helper'

RSpec.describe Block, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:blocked).class_name('User').required }
end
