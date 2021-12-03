require 'rails_helper'

RSpec.describe Streamer, type: :model do
  it { should validate_presence_of(:site_name) }
  it { should have_many(:videos) }
end
