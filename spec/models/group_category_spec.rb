require 'rails_helper'

RSpec.describe GroupCategory, type: :model do
  it { should have_many(:groups).with_foreign_key('category_id') }
end
