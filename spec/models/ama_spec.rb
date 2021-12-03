require 'rails_helper'

RSpec.describe AMA, type: :model do
  subject { build(:ama) }

  it { should belong_to(:author).required }
  it { should belong_to(:original_post).required }
end
