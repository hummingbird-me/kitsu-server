require 'rails_helper'

RSpec.describe StreamingLink, type: :model do
  include_examples 'streamable'

  it { is_expected.to belong_to(:media).required }
  it { is_expected.to validate_presence_of(:url) }
end
