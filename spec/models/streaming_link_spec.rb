require 'rails_helper'

RSpec.describe StreamingLink, type: :model do
  include_examples 'streamable'

  it { should belong_to(:media).required }
  it { should validate_presence_of(:url) }
end
