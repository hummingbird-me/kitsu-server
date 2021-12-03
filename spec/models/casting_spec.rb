require 'rails_helper'

RSpec.describe Casting, type: :model do
  it { should belong_to(:media) }
  # TODO: test validation of either character or person
end
