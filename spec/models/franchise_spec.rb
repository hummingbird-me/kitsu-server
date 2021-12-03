require 'rails_helper'

RSpec.describe Franchise, type: :model do
  include_examples 'titleable'
  it { should have_many(:installments) }
end
