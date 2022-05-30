require 'rails_helper'

RSpec.describe CategoryFavorite, type: :model do
  subject { build(:category_favorite) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:category).required }
end
