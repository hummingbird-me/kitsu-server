require 'rails_helper'

RSpec.describe AMA, type: :model do
  subject { build(:ama) }

  it { is_expected.to belong_to(:author).required }
  it { is_expected.to belong_to(:original_post).required }
end
