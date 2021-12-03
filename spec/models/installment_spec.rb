require 'rails_helper'

RSpec.describe Installment, type: :model do
  it { should belong_to(:media).required }
  it { should belong_to(:franchise).required }
end
