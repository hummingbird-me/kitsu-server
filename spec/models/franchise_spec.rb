require 'rails_helper'

RSpec.describe Franchise, type: :model do
  include_examples 'titleable'
  it { is_expected.to have_many(:installments) }
end
