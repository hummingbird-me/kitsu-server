require 'rails_helper'

RSpec.describe AMASubscriber, type: :model do
  subject { build(:ama_subscriber) }

  it { should belong_to(:ama).required }
  it { should belong_to(:user).required }
end
