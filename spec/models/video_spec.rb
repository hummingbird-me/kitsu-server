require 'rails_helper'

RSpec.describe Video, type: :model do
  include_examples 'streamable'

  it { should belong_to(:episode).required }
  it { should validate_presence_of(:url) }
end
