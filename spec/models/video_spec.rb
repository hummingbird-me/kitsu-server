require 'rails_helper'

RSpec.describe Video, type: :model do
  include_examples 'streamable'

  it { is_expected.to belong_to(:episode).required }
  it { is_expected.to validate_presence_of(:url) }
end
