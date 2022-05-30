require 'rails_helper'

RSpec.describe Streamer, type: :model do
  it { is_expected.to validate_presence_of(:site_name) }
  it { is_expected.to have_many(:videos) }
end
