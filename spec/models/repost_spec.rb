require 'rails_helper'

RSpec.describe Repost, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:post).required }
end
