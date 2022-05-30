require 'rails_helper'

RSpec.describe AMASubscriber, type: :model do
  subject { build(:ama_subscriber) }

  it { is_expected.to belong_to(:ama).required }
  it { is_expected.to belong_to(:user).required }
end
