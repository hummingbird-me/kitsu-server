require 'rails_helper'

RSpec.describe Installment, type: :model do
  it { is_expected.to belong_to(:media).required }
  it { is_expected.to belong_to(:franchise).required }
end
