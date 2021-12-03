require 'rails_helper'

RSpec.describe CategoryFavorite, type: :model do
  subject { build(:category_favorite) }

  it { should belong_to(:user).required }
  it { should belong_to(:category).required }
end
