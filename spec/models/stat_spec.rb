require 'rails_helper'

RSpec.describe Stat, type: :model do
  subject { described_class.new }

  it { should belong_to(:user) }
  it { should validate_presence_of(:type) }
end
